import db from "@db/db";
import { tables } from "@utils/constants";

export async function allSources() {
  const sources = await db.select("id", "name").from(tables.news_source);
  return { sources };
}
