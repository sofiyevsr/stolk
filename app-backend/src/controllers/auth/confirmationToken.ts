import db from "@db/db";
import i18next from "@translate/i18next";
import { confirmationTokenBackoffMinutes, tables } from "@utils/constants";
import { comparePassword, generateConfirmationToken } from "@utils/credUtils";
import SoftError from "@utils/softError";
import confirmationToken from "@utils/validations/auth/confirmationToken";
import accountConfirmationEmail from "@utils/email/accountConfirmation";
import dayjs from "dayjs";

export async function createConfirmationToken(body: any) {
  const { value, error } =
    confirmationToken.createConfirmationToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { email } = value;
  const [user] = await db(`${tables.app_user} as au`)
    // first name required for email
    .select(["au.id", "au.email", "bu.first_name"])
    .leftJoin(`${tables.base_user} as bu`, "bu.id", "au.id")
    .where({ "au.email": email, "bu.confirmed_at": null });
  if (user == null) return false;
  const confirmationTokenSession = await db(tables.confirmation_token)
    .select(["issued_at"])
    .where({
      user_id: user.id,
    })
    .first();
  if (confirmationTokenSession != null) {
    const issuedAt = dayjs(confirmationTokenSession.issued_at);
    const difference = issuedAt.diff(dayjs(), "minute");
    if (difference < confirmationTokenBackoffMinutes) {
      throw new SoftError(i18next.t("errors.backoff_confirmation_token"));
    }
  }
  const token = await generateConfirmationToken();
  await db(tables.confirmation_token)
    .insert({
      token: token.hash,
      user_id: user.id,
      issued_at: db.fn.now(),
    })
    .onConflict("user_id")
    .merge();
  await accountConfirmationEmail({
    token: token.plain,
    to: user.email,
    firstName: user.first_name,
    id: user.id,
  }).catch((e) => {
    console.log("mail error", e);
  });
  return true;
}

export async function verifyEmail(body: any) {
  const { value, error } =
    confirmationToken.validateConfirmationToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { id, token } = value;
  const confirmationTokenSession = await db(tables.confirmation_token)
    .select(["token"])
    .where({
      user_id: id,
    })
    .first();
  if (confirmationTokenSession == null) {
    throw new SoftError(i18next.t("errors.confirmation_fail"));
  }
  const isMatch = await comparePassword(token, confirmationTokenSession.token);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.confirmation_fail"));
  }
  const trx = await db.transaction();
  try {
    await trx(tables.base_user)
      .update({ confirmed_at: trx.fn.now() })
      .where({ id });
    await trx(tables.confirmation_token).where({ user_id: id }).del();
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}
