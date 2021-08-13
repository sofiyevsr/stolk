import db from "@db/db";
import { tables } from "@utils/constants";

export async function allSources(userID?: number) {
  let query = db
    .select("s.id", "s.name", "s.logo_suffix", "s.lang_id")
    .from(`${tables.news_source} as s`)
    .orderBy("s.name", "asc");
  if (userID != null) {
    query = query
      .select(db.raw("min(f.id) as follow_id"))
      .leftJoin(`${tables.source_follow} as f`, function () {
        this.on("f.source_id", "s.id");
        this.andOnVal("f.user_id", "=", userID);
      })
      .groupBy("s.id");
  }
  const sources = await query;
  return { sources };
}
