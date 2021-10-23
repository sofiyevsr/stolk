import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import limitManager from "@utils/limitManager";
import SoftError from "@utils/softError";
import validateNotificationToken from "@utils/validations/auth/notificationToken";

const saveTokenToDb = async (token: string, user_id: number) => {
  if (token == null || typeof token !== "string" || token.length < 15) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }
  await validateNotificationToken(token);
  await limitManager.limitFCMTokenSave(user_id);
  const tokenDB = await db(tables.notification_token)
    .select("token", "user_id")
    .where({
      token,
    })
    .first();
  // Nothing to do returning...
  if (tokenDB && tokenDB.user_id === user_id) return;
  await db(tables.notification_token)
    .insert({
      token,
      user_id,
    })
    .onConflict("token")
    .merge();
};

export default saveTokenToDb;
