import { PAGINATION_LIMIT } from "@admin/utils/constants";
import db from "@config/db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

async function users(lastID: string | undefined) {
  let query = db
    .select(
      "bu.id",
      "bu.first_name",
      "bu.last_name",
      db.raw("COALESCE(au.email, ou.email) as email"),
      "bu.banned_at",
      "bu.confirmed_at",
      "bu.created_at",
      "ou.service_type_id"
    )
    .from(`${tables.base_user} as bu`)
    .leftJoin(`${tables.app_user} as au`, "au.id", "bu.id")
    .leftJoin(`${tables.oauth_user} as ou`, "ou.id", "bu.id")
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
