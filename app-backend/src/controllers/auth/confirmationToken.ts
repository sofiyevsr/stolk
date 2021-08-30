import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import { comparePassword, generateConfirmationToken } from "@utils/credUtils";
import SoftError from "@utils/softError";
import confirmationToken from "@utils/validations/auth/confirmationToken";
import mailService from "@utils/mailService";

export async function createConfirmationToken(body: any) {
  const { value, error } =
    confirmationToken.createConfirmationToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { email } = value;
  const [user] = await db(tables.app_user)
    .select(["id", "email"])
    .where({ email, confirmed_at: null });
  if (user == null) return false;
  const token = await generateConfirmationToken();
  const data = await db(tables.confirmation_token)
    .insert({
      token: token.hash,
      user_id: user.id,
    })
    .onConflict("user_id")
    .merge();
  await mailService
    .sendMail(user.email, "Confirm Email", `<div>${token.plain}</div>`)
    .catch((e) => {});
  return true;
}

export async function verifyEmail(body: any) {
  const { value, error } =
    confirmationToken.validateConfirmationToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { id, token } = value;
  const [confirmationTokenSession] = await db(tables.confirmation_token)
    .select(["token"])
    .where({
      user_id: id,
    });
  if (confirmationTokenSession == null) {
    throw new SoftError(i18next.t("errors.confirmation_fail"));
  }
  const isMatch = await comparePassword(token, confirmationTokenSession.token);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.confirmation_fail"));
  }
  const trx = await db.transaction();
  try {
    await trx(tables.app_user)
      .update({ confirmed_at: trx.fn.now() })
      .where({ id });
    await trx(tables.confirmation_token).where({ user_id: id }).del();
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}
