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
      "bu.ip_address",
      "bu.banned_at",
      "bu.confirmed_at",
      "bu.created_at",
      "ou.service_type_id",
      db.raw("COUNT(ss.id) as session_count"),
      db.raw("COUNT(nt.token) as notification_token_count")
    )
    .from(`${tables.base_user} as bu`)
    .leftJoin(`${tables.app_user} as au`, "au.id", "bu.id")
    .leftJoin(`${tables.oauth_user} as ou`, "ou.id", "bu.id")
    .leftJoin(`${tables.user_session} as ss`, "ss.user_id", "bu.id")
    .leftJoin(`${tables.notification_token} as nt`, "nt.session_id", "ss.id")
    .groupBy("bu.id", "ou.id", "au.id")
    .orderBy("bu.id", "desc")
    .limit(PAGINATION_LIMIT + 1);
  if (lastID != null) {
    const val = await Joi.number().validateAsync(lastID);
    query = query.andWhere("bu.id", "<", val);
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
