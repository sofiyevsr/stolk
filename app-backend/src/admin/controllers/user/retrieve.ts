import { PAGINATION_LIMIT } from "@admin/utils/constants";
import db from "@config/db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

async function users(lastID: string | undefined) {
  let query = db
    .select(
      "id",
      "first_name",
      "last_name",
      "email",
      "banned_at",
      "confirmed_at",
      "created_at"
    )
    .from(`${tables.app_user}`)
    .orderBy("id", "desc")
    .limit(PAGINATION_LIMIT + 1);
  if (lastID != null) {
    const val = await Joi.number().validateAsync(lastID);
    query = query.andWhere("id", "<", val);
  }
  let users = await query;
  const hasReachedEnd = users.length !== PAGINATION_LIMIT + 1;
  users = users.slice(0, PAGINATION_LIMIT);

  const result = {
    users,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

export { users };
