import db from "@config/db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

async function logout(session_id?: number, user_id?: number, token?: any) {
  if (session_id == null) {
    throw new SoftError(i18next.t("errors.invalid_session_id"));
  }
  const trx = await db.transaction();
  try {
    if (typeof token === "string" && token.length > 15) {
      const deletedTokens = await trx(tables.notification_token)
        .where({ token, user_id })
        .del();
    }
    const deletedSession = await trx(tables.user_session)
      .where({ id: session_id })
      .del();
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}

export default logout;
