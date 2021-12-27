import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import validateNotificationToken from "@utils/validations/auth/notificationToken";

const saveTokenToDb = async (token: string, session_id?: number) => {
  if (token == null || typeof token !== "string" || token.length < 15) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }
  await validateNotificationToken(token);
  const tokenDB = await db(tables.notification_token)
    .select("token", "session_id")
    .where({
      token,
      session_id: session_id ?? null,
    })
    .first();
  // Nothing to do returning...
  if (tokenDB) return;
  await db(tables.notification_token)
    .insert({
      token,
      session_id: session_id ?? null,
    })
    .onConflict("session_id")
    .merge();
};

export default saveTokenToDb;
