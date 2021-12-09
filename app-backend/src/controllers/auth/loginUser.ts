import db from "@config/db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import { comparePassword, generateAccessToken } from "@utils/credUtils";
import SoftError from "@utils/softError";
import login from "@utils/validations/auth/login";

export default async function loginUser(body: any, ip: string) {
  const { value, error } = login.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  const dbUser = await db(`${tables.app_user} as au`)
    .select([
      "u.id as user_id",
      "au.password",
      "au.email",
      "u.created_at",
      "u.first_name",
      "u.last_name",
      "u.banned_at",
      "u.confirmed_at",
      "u.completed_at",
    ])
    .where({ "au.email": value.email })
    .leftJoin(`${tables.base_user} as u`, "u.id", "au.id")
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
    ip_address: ip,
    token,
  });

  return { user, access_token: token };
}
