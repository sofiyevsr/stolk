import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

const saveTokenToDb = async (token: string, user_id?: number) => {
  if (token == null || typeof token !== "string" || token.length < 15) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }
  let user = null;
  if (user_id != null) {
    user = user_id;
  }
  console.log(user);
  await db(tables.notification_token)
    .insert({
      token,
      user_id: user,
    })
    .onConflict("token")
    .merge();
};

export default saveTokenToDb;
