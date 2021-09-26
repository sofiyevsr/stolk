import db from "@config/db/db";
import i18next from "@translate/i18next";
import { ServiceType, tables } from "@utils/constants";
import { comparePassword, generateAccessToken } from "@utils/credUtils";
import SoftError from "@utils/softError";
import login from "@utils/validations/auth/login";

export default async function loginUser(body: any) {
  const { value, error } = login.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const dbUser = await db(tables.app_user)
    .select([
      "id as user_id",
      "password",
      "service_type_id",
      "email",
      "created_at",
      "first_name",
      "last_name",
      "banned_at",
      "confirmed_at",
    ])
    .where({ email: value.email, service_type_id: ServiceType.APP })
    .first();

  if (dbUser == null) {
    throw new SoftError(i18next.t("errors.login_fail"), 400);
  }
  if (dbUser.banned_at != null) {
    throw new SoftError(i18next.t("errors.account_banned"), 403);
  }

  const { password, ...user } = dbUser;

  const isMatch = await comparePassword(value.password, password);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.login_fail"), 400);
  }

  const token = await generateAccessToken({
    id: user.user_id,
    platform: value.session_type,
  });

  const session = await db(tables.user_session).insert({
    session_type_id: value.session_type,
    user_id: user.user_id,
    token,
  });

  return { user, access_token: token };
}
