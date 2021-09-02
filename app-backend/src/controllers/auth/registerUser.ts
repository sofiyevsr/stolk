import SoftError from "@utils/softError";
import register from "@utils/validations/auth/register";
import db from "@db/db";
import { generateAccessToken, hashPassword } from "@utils/credUtils";
import { tables } from "@utils/constants";
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
  // Write user to db
  const [user] = await db(tables.app_user).insert(
    {
      first_name: value.first_name,
      last_name: value.last_name,
      email: value.email,
      password: hash,
      service_type_id: value.service_type,
    },
    [
      "id as user_id",
      "service_type_id",
      "email",
      "created_at",
      "first_name",
      "last_name",
      "banned_at",
      "confirmed_at",
    ]
  );
  await createConfirmationToken({ email: user.email });

  // TODO send verification code to email
  const token = await generateAccessToken({
    id: user.user_id,
    platform: value.session_type,
  });

  // Create session for user
  const session = await db(tables.user_session).insert({
    session_type_id: value.session_type,
    user_id: user.user_id,
    token,
  });
  return { user, access_token: token };
}
