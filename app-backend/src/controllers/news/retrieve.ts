import db from "@config/db/db";
import { DEFAULT_PERPAGE, MAX_PERPAGE, tables } from "@utils/constants";
import parseCats from "./helpers/categoryParser";

async function all(perPage?: string, lastCreatedAt?: string, cats?: string) {
  let query = db
    .select([
      "s.id AS source_id",
      "s.name AS source_name",
      "n.id",
      "n.title",
      "n.description",
      "n.image_link",
      "n.pub_date",
      "n.created_at",
      "n.feed_link",
      "c.name as category_name",
    ])
    .from(`${tables.news_feed} as n`)
    .leftJoin(`${tables.news_source} as s`, "n.source_id", "s.id")
    .leftJoin(
      `${tables.news_category_alias} as ca`,
      "ca.id",
      "n.category_alias_id"
    )
    .leftJoin(`${tables.news_category} as c`, "c.id", "ca.category_id")
    .orderBy("pub_date", "desc");

  if (lastCreatedAt != null) {
    query = query.andWhere("n.pub_date", "<", lastCreatedAt);
  }

  if (parseCats(cats) != null) {
    query = query.where((builder) =>
      builder.whereIn("c.category_id", parseCats(cats)!)
    );
  }

  const parsedPerPage =
    Number.isNaN(Number(perPage)) === true ? DEFAULT_PERPAGE : Number(perPage);
  const limit = parsedPerPage > MAX_PERPAGE ? MAX_PERPAGE : parsedPerPage;
  query = query.limit(limit + 1);

  let news = await query;
  const hasReachedEnd = news.length !== parsedPerPage + 1;
  news = news.slice(0, parsedPerPage);

  return { news, has_reached_end: hasReachedEnd };
}

export default {
  all,
};
