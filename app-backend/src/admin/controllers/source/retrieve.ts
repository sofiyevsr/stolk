import db from "@db/db";
import { tables } from "@utils/constants";

export async function allSources() {
  const sources = await db
    .select(
      "s.id",
      "s.name",
      "s.created_at",
      "s.category_alias_name",
      "s.logo_suffix",
      "s.link",
      "s.lang_id",
      "l.name as language",
      db.raw("max(n.pub_date) as latest_news_date")
    )
    .from(`${tables.news_source} as s`)
    .leftJoin(`${tables.language} as l`, "s.lang_id", "l.id")
    .leftJoin(`${tables.news_feed} as n`, "n.source_id", "s.id")
    .groupBy("s.id", "l.id");

  return { sources };
}
