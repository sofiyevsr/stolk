import db from "@config/db/db";
import { DEFAULT_PERPAGE, MAX_PERPAGE, tables } from "@utils/constants";
import Joi from "joi";

interface NewsResult {
  news: any[];
  has_reached_end: boolean;
}

async function all(
  perPage?: string,
  lastCreatedAt?: string,
  cat?: string,
  user_id?: number
) {
  let result: NewsResult;
  let query = db
    .select([
      "s.id AS source_id",
      "s.name AS source_name",
      "n.id",
      "n.title",
      "n.image_link",
      "n.pub_date",
      "n.created_at",
      "n.feed_link",
      "c.id as category_id",
      "c.name as category_name",
      "n.like_count",
      "n.comment_count",
    ])
    .from(`${tables.news_feed} as n`)
    .leftJoin(`${tables.news_source} as s`, "n.source_id", "s.id")
    .leftJoin(
      `${tables.news_category_alias} as ca`,
      "ca.id",
      "n.category_alias_id"
    )
    .leftJoin(`${tables.news_category} as c`, "c.id", "ca.category_id")
    .orderBy("pub_date", "desc")
    .groupBy("n.id", "s.id", "c.id");

  if (user_id != null) {
    query = query
      .select(
        db.raw("min(bo.id) as bookmark_id"),
        db.raw("min(l.id) as like_id")
      )
      .leftJoin(`${tables.source_follow} as f`, "f.source_id", "s.id")
      .leftJoin(`${tables.news_bookmark} as bo`, function () {
        this.on("bo.news_id", "n.id");
        this.andOnVal("bo.user_id", "=", user_id);
      })
      .leftJoin(`${tables.news_like} as l`, function () {
        this.on("l.news_id", "n.id");
        this.andOnVal("l.user_id", "=", user_id);
      })
      .where({ "f.user_id": user_id });
  }

  if (lastCreatedAt != null) {
    await Joi.date().validateAsync(lastCreatedAt);
    query = query.andWhere("n.pub_date", "<", lastCreatedAt);
  }

  if (cat != null) {
    const val = await Joi.number().min(1).max(200).validateAsync(cat);
    query = query.where((builder) => builder.where("c.id", val));
  }

  const parsedPerPage =
    Number.isNaN(Number(perPage)) === true ? DEFAULT_PERPAGE : Number(perPage);
  const limit = parsedPerPage > MAX_PERPAGE ? MAX_PERPAGE : parsedPerPage;
  query = query.limit(limit + 1);

  let news = await query;
  const hasReachedEnd = news.length !== parsedPerPage + 1;
  news = news.slice(0, parsedPerPage);

  result = {
    news,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

async function allCategories() {
  const categories = await db.select("id", "name").from(tables.news_category);
  return { categories };
}

export default {
  all,
  allCategories,
};
