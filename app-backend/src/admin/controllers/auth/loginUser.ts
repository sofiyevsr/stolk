import db from "@config/db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import { comparePassword, generateAccessToken } from "@admin/utils/credUtils";
import SoftError from "@utils/softError";
import login from "@admin/utils/validations/auth/login";

export default async function loginUser(body: any) {
  const { value, error } = login.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  const dbUser = await db(tables.admin_user)
    .select([
      "id",
      "password",
      "email",
      "created_at",
      "first_name",
      "last_name",
    ])
    .where({ email: value.email })
    .first();

  if (dbUser == null) {
    throw new SoftError(i18next.t("errors.login_fail"), 400);
  }

  const { password, ...user } = dbUser;

  const isMatch = await comparePassword(value.password, password);
  if (isMatch === false) {
    throw new SoftError(i18next.t("errors.login_fail"), 400);
  }

  const token = await generateAccessToken({
    id: user.id,
  });

  const session = await db(tables.admin_user)
    .update({
      token,
    })
    .where({ id: user.id });

  return { user, access_token: token };
}
