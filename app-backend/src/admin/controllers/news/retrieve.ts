import { PAGINATION_LIMIT } from "@admin/utils/constants";
import db from "@config/db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

interface NewsResult {
  news: any[];
  has_reached_end: boolean;
}

async function all(lastID: string | undefined) {
  let result: NewsResult;
  let query = db
    .select([
      "n.id",
      "n.title",
      "n.image_link",
      "n.pub_date",
      "n.created_at",
      "n.feed_link",
      "n.like_count",
      "n.comment_count",
      "n.hidden_at",
      "s.id AS source_id",
      "s.name AS source_name",
      "s.logo_suffix AS source_logo_suffix",
      "c.id as category_id",
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
    .orderBy("n.id", "desc")
    .limit(PAGINATION_LIMIT + 1);
  if (lastID != null) {
    const val = await Joi.number().validateAsync(lastID);
    query = query.andWhere("n.id", "<", val);
  }
  let news = await query;
  const hasReachedEnd = news.length !== PAGINATION_LIMIT + 1;
  news = news.slice(0, PAGINATION_LIMIT);

  result = {
    news,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

async function comments(lastID: string | undefined) {
  let query = db
    .select(
      "c.id",
      "c.comment",
      "u.first_name",
      "u.last_name",
      "c.user_id",
      "c.created_at"
    )
    .from(`${tables.news_comment} as c`)
    .leftJoin(`${tables.app_user} as u`, "c.user_id", "u.id")
    .orderBy("id", "desc")
    .limit(PAGINATION_LIMIT + 1);
  if (lastID != null) {
    const val = await Joi.number().validateAsync(lastID);
    query = query.andWhere("c.id", "<", val);
  }
  let comments = await query;
  const hasReachedEnd = comments.length !== PAGINATION_LIMIT + 1;
  comments = comments.slice(0, PAGINATION_LIMIT);

  const result = {
    comments,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

async function allCategories() {
  const categories = await db
    .select("id", "name", "created_at")
    .from(tables.news_category);
  return { categories };
}

async function allCategoryAliases() {
  const categories = await db
    .select(
      "ca.id",
      "ca.alias",
      "c.id as category_id",
      "c.name as category_name"
    )
    .from(`${tables.news_category_alias} as ca`)
    .leftJoin(`${tables.news_category} as c`, "ca.category_id", "c.id")
    .orderBy("ca.id", "asc");
  return { categories };
}

export default {
  all,
  allCategories,
  allCategoryAliases,
  comments,
};
