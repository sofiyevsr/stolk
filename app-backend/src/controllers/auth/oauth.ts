import db from "@config/db/db";
import i18next from "@translate/i18next";
import {
  AppPlatform,
  newRegistrationBackoffCounts,
  ServiceType,
  SessionType,
  tables,
} from "@utils/constants";
import { generateAccessToken } from "@utils/credUtils";
import SoftError from "@utils/softError";
import oauth from "@utils/validations/auth/oauth";
import { OAuth2Client, TokenPayload } from "google-auth-library";

// User id required for session creation
async function loginUser(id: number, ip: string) {
  const token = await generateAccessToken({
    id,
    platform: AppPlatform.ANDROID,
  });

  const session = await db(tables.user_session).insert({
    // FOR NOW ONLY ANDROID should have google sign in
    session_type_id: SessionType.ANDROID,
    user_id: id,
    ip_address: ip,
    token,
  });
  return { token };
}

async function registerUser(payload: TokenPayload, ip: string) {
  const trx = await db.transaction();
  // DB data
  let baseUser, user;
  try {
    const baseResult = await trx(tables.base_user).insert(
      {
        first_name: payload.given_name,
        last_name: payload.family_name,
        ip_address: ip,
        confirmed_at: db.fn.now(),
      },
      [
        "id as user_id",
        "first_name",
        "last_name",
        "confirmed_at",
        "banned_at",
        "created_at",
      ]
    );
    baseUser = baseResult[0];
    const oauthResult = await trx(tables.oauth_user).insert(
      {
        id: baseUser.user_id,
        email: payload.email,
        oauth_id: payload.sub,
        service_type_id: ServiceType.GOOGLE,
      },
      ["service_type_id", "email"]
    );
    user = oauthResult[0];
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
  const { token } = await loginUser(baseUser.user_id, ip);
  return { token, user: { ...user, ...baseUser } };
}

async function googleLoginUser(body: any, ip: string) {
  const { value, error } = oauth.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const client = new OAuth2Client(process.env.GOOGLE_WEB_CLIENT_ID);
  const ticket = await client.verifyIdToken({
    idToken: value.token,
    audience: process.env.GOOGLE_WEB_CLIENT_ID,
  });
  const payload = ticket.getPayload();

  // Does user exist if does then login else register
  if (payload == null)
    throw new SoftError(i18next.t("errors.google_empty_payload"));

  const user = await db(`${tables.oauth_user} as ou`)
    .select([
      "u.id as user_id",
      "ou.service_type_id",
      "ou.email",
      "u.created_at",
      "u.first_name",
      "u.last_name",
      "u.banned_at",
      "u.confirmed_at",
    ])
    .where({ oauth_id: payload.sub, service_type_id: ServiceType.GOOGLE })
    .leftJoin(`${tables.base_user} as u`, "u.id", "ou.id")
    .first();

  if (user == null) {
    if (
      payload.email == null ||
      payload.given_name == null ||
      payload.family_name == null
    )
      throw new SoftError(i18next.t("errors.google_data_not_complete"));

    const { user: dbUser, token } = await registerUser(payload, ip);
    return { user: dbUser, access_token: token };
  }

  if (user.banned_at != null) {
    throw new SoftError(i18next.t("errors.account_banned"), 403);
  }

  const { token } = await loginUser(user.user_id, ip);

  return { user, access_token: token };
}

export default {
  googleLoginUser,
};
