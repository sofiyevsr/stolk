import db from "@config/db/db";
import { DEFAULT_PERPAGE, MAX_PERPAGE, tables } from "@utils/constants";
import Joi from "joi";

interface NewsResult {
  news: any[];
  has_reached_end: boolean;
}

function validateAllNewsRequest() {
  return Joi.object({
    filterBy: Joi.string().valid("like", "history", "bookmark", "comment"),
    userID: Joi.any().when("filterBy", {
      then: Joi.number().required(),
      otherwise: Joi.number(),
    }),
    sourceID: Joi.number().min(0),
  }).options({ stripUnknown: true });
}

async function all(
  perPage?: string,
  lastCreatedAt?: string,
  cat?: string,
  userID?: number,
  sourceID?: string,
  filterBy?: string
) {
  const values = await validateAllNewsRequest().validateAsync({
    userID,
    filterBy,
    sourceID,
  });
  let result: NewsResult;
  let query = db
    .select([
      "s.id AS source_id",
      "s.name AS source_name",
      "s.logo_suffix AS source_logo_suffix",
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

  if (userID != null) {
    query = query
      .select(
        db.raw("min(bo.id) as bookmark_id"),
        db.raw("min(l.id) as like_id"),
        db.raw("min(f.id) as follow_id"),
        db.raw("min(h.id) as read_history_id")
      )
      .leftJoin(`${tables.source_follow} as f`, "f.source_id", "s.id")
      .leftJoin(`${tables.news_bookmark} as bo`, function () {
        this.on("bo.news_id", "n.id");
        this.andOnVal("bo.user_id", "=", userID);
      })
      .leftJoin(`${tables.news_like} as l`, function () {
        this.on("l.news_id", "n.id");
        this.andOnVal("l.user_id", "=", userID);
      })
      .leftJoin(`${tables.news_read_history} as h`, function () {
        this.on("h.news_id", "n.id");
        this.andOnVal("h.user_id", "=", userID);
      });
    if (values.filterBy === "like") {
      query = query.where({ "l.user_id": userID });
    } else if (values.filterBy === "bookmark") {
      query = query.where({ "bo.user_id": userID });
    } else if (values.filterBy === "history") {
      query = query.where({ "h.user_id": userID });
    } else if (values.filterBy === "comment") {
      query = query
        .leftJoin(`${tables.news_comment} as co`, function () {
          this.on("co.news_id", "n.id");
          this.andOnVal("co.user_id", "=", userID);
        })
        .where({ "co.user_id": userID });
    } else if (values.sourceID != null) {
      query = query.where({ "s.id": values.sourceID });
    } else {
      query = query.where({ "f.user_id": userID });
    }
  } else if (values.sourceID != null) {
    query = query.where({ "s.id": values.sourceID });
  }

  if (lastCreatedAt != null) {
    await Joi.date().validateAsync(lastCreatedAt);
    query = query.andWhere("n.pub_date", "<", lastCreatedAt);
  }

  if (cat != null && values.filterBy == null) {
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

async function comments(news_id: number, id?: string) {
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
    .leftJoin(`${tables.app_user} as u`, "u.id", "c.user_id")
    .where({
      news_id,
    })
    .orderBy("id", "desc")
    .limit(DEFAULT_PERPAGE + 1);
  if (id != null) {
    const val = await Joi.number().validateAsync(id);
    query = query.andWhere("c.id", "<", val);
  }
  let comments = await query;
  const hasReachedEnd = comments.length !== DEFAULT_PERPAGE + 1;
  comments = comments.slice(0, DEFAULT_PERPAGE);

  const result = {
    comments,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

export default {
  all,
  allCategories,
  comments,
};
