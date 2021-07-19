import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

export const like = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.news_id_required"));
  const [like] = await db(tables.news_like).insert(
    {
      user_id,
      news_id: id,
    },
    ["id"]
  );
  return like;
};

export const unlike = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.news_id_required"));
  const like = await db(tables.news_like).del("id").where({
    user_id,
    news_id: id,
  });
  return like;
};
