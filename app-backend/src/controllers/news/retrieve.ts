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
    userID: Joi.number(),
    sourceID: Joi.number().min(0),
  }).options({ stripUnknown: true });
}

function validateHistoryNewsRequest() {
  return Joi.object({
    filterBy: Joi.string()
      .valid("like", "history", "bookmark", "comment")
      .required(),
    userID: Joi.number().required(),
    id: Joi.number(),
  }).options({ stripUnknown: true });
}

async function all(
  perPage?: string,
  lastCreatedAt?: string,
  cat?: string,
  userID?: number,
  sourceID?: string
) {
  const values: { sourceID: number; userID: number } =
    await validateAllNewsRequest().validateAsync({
      userID,
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
    .where({ "n.hidden_at": null })
    .orderBy("pub_date", "desc");

  if (userID != null) {
    query = query
      .select(
        "bo.id as bookmark_id",
        "l.id as like_id",
        "f.id as follow_id",
        "h.id as read_history_id",
        "co.id as comment_id"
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
      })
      .leftJoin(`${tables.news_comment} as co`, function () {
        this.on("co.news_id", "n.id");
        this.andOnVal("co.user_id", "=", values.userID);
      });
    if (values.sourceID != null) {
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

async function usersNewsHistory(
  perPage?: string,
  id?: string,
  userID?: number,
  filterBy?: string
) {
  const values = await validateHistoryNewsRequest().validateAsync({
    userID,
    filterBy,
    id,
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
      "bo.id as bookmark_id",
      "l.id as like_id",
      "f.id as follow_id",
      "h.id as read_history_id",
      "co.id as comment_id",
    ])
    .from(`${tables.news_feed} as n`)
    .leftJoin(`${tables.news_source} as s`, "n.source_id", "s.id")
    .leftJoin(
      `${tables.news_category_alias} as ca`,
      "ca.id",
      "n.category_alias_id"
    )
    .leftJoin(`${tables.news_category} as c`, "c.id", "ca.category_id")
    .leftJoin(`${tables.source_follow} as f`, "f.source_id", "s.id")
    .leftJoin(`${tables.news_comment} as co`, function () {
      this.on("co.news_id", "n.id");
      this.andOnVal("co.user_id", "=", values.userID);
    })
    .leftJoin(`${tables.news_bookmark} as bo`, function () {
      this.on("bo.news_id", "n.id");
      this.andOnVal("bo.user_id", "=", values.userID);
    })
    .leftJoin(`${tables.news_like} as l`, function () {
      this.on("l.news_id", "n.id");
      this.andOnVal("l.user_id", "=", values.userID);
    })
    .leftJoin(`${tables.news_read_history} as h`, function () {
      this.on("h.news_id", "n.id");
      this.andOnVal("h.user_id", "=", values.userID);
    })
    .where({ "n.hidden_at": null });

  if (values.filterBy === "like") {
    query = query.where({ "l.user_id": userID }).orderBy("l.id", "desc");
    if (values.id != null) {
      query = query.where("l.id", "<", values.id);
    }
  } else if (values.filterBy === "bookmark") {
    query = query.where({ "bo.user_id": userID }).orderBy("bo.id", "desc");
    if (values.id != null) {
      query = query.where("bo.id", "<", values.id);
    }
  } else if (values.filterBy === "history") {
    query = query.where({ "h.user_id": userID }).orderBy("h.id", "desc");
    if (values.id != null) {
      query = query.where("h.id", "<", values.id);
    }
  } else if (values.filterBy === "comment") {
    query = query.where({ "co.user_id": userID }).orderBy("co.id", "desc");
    if (values.id != null) {
      query = query.where("co.id", "<", values.id);
    }
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
  usersNewsHistory,
  comments,
};
