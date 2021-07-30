import SoftError from "@utils/softError";
import register from "@utils/validations/auth/register";
import db from "@db/db";
import { generateAccessToken, hashPassword } from "@utils/credUtils";
import { tables } from "@utils/constants";

export default async function registerUser(body: any) {
  const { value, error } = register.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const hash = await hashPassword(value.password);
  const [user] = await db(tables.app_user)
    .insert(
      {
        first_name: value.first_name,
        last_name: value.last_name,
        email: value.email,
        password: hash,
        service_type_id: value.service_type,
      },
      [
        "id as user_id",
        "first_name",
        "last_name",
        "email",
        "created_at",
        "service_type_id",
      ]
    )
    .catch((err) => {
      // TODO 23505 unique violation
      console.log(err);
      throw err;
    });

  // TODO send verification code to email
  const token = await generateAccessToken({
    id: user.id,
    platform: value.session_type,
  });

  const session = await db(tables.user_session).insert({
    session_type_id: value.session_type,
    user_id: user.id,
    token,
  });
  return { user, access_token: token };
}
