import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

export const follow = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.source_id_required"));
  await db(tables.source_follow)
    .insert(
      {
        user_id,
        source_id: id,
      },
      ["id"]
    )
    .catch((err) => {
      if (err.code !== "23505") throw err;
    });
};

export const unfollow = async (id: string, user_id: number) => {
  const parsedID = Number(id);
  if (Number.isNaN(parsedID))
    throw new SoftError(i18next.t("errors.source_id_required"));
  const unfollow = await db(tables.source_follow).del().where({
    user_id,
    source_id: id,
  });
  return unfollow;
};
