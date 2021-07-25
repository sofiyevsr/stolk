import db from "@db/db";
import { tables } from "@utils/constants";

export async function allSources() {
  const sources = await db
    .select("id", "name", "logo_suffix", "lang_id")
    .from(tables.news_source);
  return { sources };
}
