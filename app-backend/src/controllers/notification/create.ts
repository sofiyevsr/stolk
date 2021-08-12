import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

const saveTokenToDb = async (token: string, user_id: number) => {
  if (token == null || typeof token !== "string" || token.length < 15) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }
  const dbTokens = await db(tables.notification_token).select("id").where({
    token,
    user_id,
  });
  if (dbTokens.length != 0) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }

  await db(tables.notification_token)
    .insert({
      token,
      user_id,
    })
    .onConflict("user_id")
    .merge();
};

export default saveTokenToDb;
