import db from "@db/db";
import { tables } from "@utils/constants";

export const read = async (
  newsID: string,
  userID: number | undefined,
  ip: string
) => {
  if (userID != null) {
    const [read] = await db(tables.news_read_history).insert(
      {
        user_id: userID,
        news_id: newsID,
      },
      ["id", "user_id", "ip_address", "created_at"]
    );
    return read;
  }
  const read = await db(tables.news_read_history)
    .select("id")
    .where({ ip_address: ip })
    .first();
  if (read == null) {
    const [read] = await db(tables.news_read_history).insert(
      {
        ip_address: ip,
        news_id: newsID,
      },
      ["id", "user_id", "ip_address", "created_at"]
    );
    return read;
  }
  return null;
};
