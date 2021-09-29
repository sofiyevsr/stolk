import SoftError from "@utils/softError";
import register from "@utils/validations/auth/register";
import db from "@db/db";
import { generateAccessToken, hashPassword } from "@utils/credUtils";
import { ServiceType, tables } from "@utils/constants";
import i18next from "@translate/i18next";
import { createConfirmationToken } from "./confirmationToken";

export default async function registerUser(body: any) {
  // Validate user
  const { value, error } = register.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  // Check if user exists
  const existingUsers = await db(tables.app_user)
    .select("id")
    .where({ email: value.email });
  if (existingUsers.length !== 0)
    throw new SoftError(i18next.t("errors.unique_email"));
  // Hash Password
  const hash = await hashPassword(value.password);

  const trx = await db.transaction();
  // db data
  let baseUser, user;
  try {
    // Write user to db
    const baseResult = await trx(tables.base_user).insert(
      {
        first_name: value.first_name,
        last_name: value.last_name,
      },
      [
        "id as user_id",
        "created_at",
        "first_name",
        "last_name",
        "banned_at",
        "confirmed_at",
      ]
    );
    baseUser = baseResult[0];
    const userResult = await trx(tables.app_user).insert(
      {
        id: baseUser.user_id,
        email: value.email,
        password: hash,
      },
      ["email"]
    );
    user = userResult[0];
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }

  await createConfirmationToken({ email: user.email });

  // TODO send verification code to email
  const token = await generateAccessToken({
    id: baseUser.user_id,
    platform: value.session_type,
  });

  // Create session for user
  const session = await db(tables.user_session).insert({
    session_type_id: value.session_type,
    user_id: baseUser.user_id,
    token,
  });
  return { user: { ...user, ...baseUser }, access_token: token };
}
