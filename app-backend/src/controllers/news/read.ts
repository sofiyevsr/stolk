import db from "@db/db";
import { tables } from "@utils/constants";

export const read = async (newsID: string, userID: number) => {
  const [read] = await db(tables.news_read_history).insert(
    {
      user_id: userID,
      news_id: newsID,
    },
    ["id", "user_id", "created_at"]
  );
  return read;
};
