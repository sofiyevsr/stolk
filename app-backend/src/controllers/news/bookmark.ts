import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

export const bookmark = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.news_id_required"));
  const bookmark = await db(tables.news_bookmark).insert(
    {
      user_id,
      news_id: id,
    },
    ["id"]
  );
  return bookmark;
};

export const unbookmark = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.news_id_required"));
  const bookmark = await db(tables.news_bookmark).del("id").where({
    user_id,
    news_id: id,
  });
  return bookmark;
};
