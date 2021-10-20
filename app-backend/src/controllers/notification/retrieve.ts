import db from "@config/db/db";
import { tables } from "@utils/constants";

// Gets subscriptions from server
export async function getAllNotificationTypesWithOptouts(userID?: number) {
  let query = db
    .select("t.id", "t.name")
    .from(`${tables.notification_type} as t`);
  if (userID != null) {
    query = query
      .select("o.created_at")
      .leftJoin(`${tables.notification_optout} as o`, function () {
        this.on("t.id", "o.notification_type_id");
        this.andOnVal("o.user_id", "=", userID);
      })
      .orderBy("t.id", "asc");
  }
  const result = await query;
  return { preferences: result };
}
