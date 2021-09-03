import db from "@db/db";
import dayjs from "dayjs";
import i18next from "@translate/i18next";
import {
  tables,
  resetTokenExpirationMinutes,
  resetTokenBackoffMinutes,
  ServiceType,
} from "@utils/constants";
import {
  comparePassword,
  generateResetToken,
  hashPassword,
} from "@utils/credUtils";
import SoftError from "@utils/softError";
import resetToken from "@utils/validations/auth/resetToken";
import resetPasswordEmail from "@utils/email/resetPassword";

export async function createResetToken(body: any) {
  const { value, error } = resetToken.createResetToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { email } = value;
  const [user] = await db(tables.app_user)
    .select(["id", "email"])
    .where({ email, service_type_id: ServiceType.APP });
  if (user == null) return false;

  const resetTokenSession = await db(tables.reset_token)
    .select(["issued_at"])
    .where({
      user_id: user.id,
    })
    .first();
  if (resetTokenSession != null) {
    const issuedAt = dayjs(resetTokenSession.issued_at);
    const difference = issuedAt.diff(dayjs(), "minute");
    if (difference < resetTokenBackoffMinutes) {
      throw new SoftError(i18next.t("errors.backoff_reset_token"));
    }
  }

  const token = await generateResetToken();
  await db(tables.reset_token)
    .insert({
      token: token.hash,
      user_id: user.id,
    })
    .onConflict("user_id")
    .merge();
  await resetPasswordEmail({ token: token.plain, to: user.email }).catch(() => {
    console.log("email error");
  });
  return true;
}

export async function validateResetToken(body: any) {
  const { value, error } = resetToken.validateToken.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { id, token } = value;
  const [resetTokenSession] = await db(tables.reset_token)
    .select(["issued_at", "token"])
    .where({
      user_id: id,
    });
  if (resetTokenSession == null) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
  const isMatch = await comparePassword(token, resetTokenSession.token);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
  const issuedAt = dayjs(resetTokenSession.issued_at);
  const difference = issuedAt.diff(dayjs(), "minute");
  if (difference > resetTokenExpirationMinutes) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
}

export async function resetPassword(body: any) {
  const { value, error } = resetToken.resetPassword.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const { token, password, id } = value;

  const [resetTokenSession] = await db(tables.reset_token)
    .select(["issued_at", "id", "token"])
    .where({
      user_id: id,
    });
  if (resetTokenSession == null) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
  const isMatch = await comparePassword(token, resetTokenSession.token);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
  const issuedAt = dayjs(resetTokenSession.issued_at);
  const difference = issuedAt.diff(dayjs(), "minute");
  if (difference > resetTokenExpirationMinutes) {
    throw new SoftError(i18next.t("errors.reset_fail"));
  }
  const hash = await hashPassword(password);
  const trx = await db.transaction();
  try {
    const updatedUser = await trx(tables.app_user)
      .where({ id })
      .update({ password: hash });
    if (updatedUser === 0) {
      throw new SoftError(i18next.t("errors.reset_fail"));
    }
    await db(tables.reset_token).where({ user_id: id }).del();
    await trx.commit();
  } catch (e) {
    await trx.rollback();
    throw e;
  }
}
