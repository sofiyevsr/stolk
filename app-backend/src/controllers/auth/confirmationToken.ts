import db from "@db/db";
import i18next from "@translate/i18next";
import {
  confirmationTokenBackoffMinutes,
  ServiceType,
  tables,
} from "@utils/constants";
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
  const [user] = await db(tables.app_user)
    // first name required for email
    .select(["id", "email", "first_name"])
    .where({ email, confirmed_at: null, service_type_id: ServiceType.APP });
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
    })
    .onConflict("user_id")
    .merge();
  await accountConfirmationEmail({
    token: token.plain,
    to: user.email,
    firstName: user.first_name,
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
