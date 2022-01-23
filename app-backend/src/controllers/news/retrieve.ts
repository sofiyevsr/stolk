import db from "@config/db/db";
import {
  DEFAULT_PERPAGE,
  MAX_PERPAGE,
  NewsSortBy,
  tables,
} from "@utils/constants";
import Joi from "joi";

interface NewsResult {
  news: any[];
  categories?: any[];
  has_reached_end: boolean;
}

interface NewsRequest {
  perPage?: string;
  lastCreatedAt?: string;
  category?: string;
  userID?: number;
  sourceID?: string;
  sortBy?: string;
  cursor?: string;
  period?: string;
}

interface BookmarksRequest {
  perPage?: string;
  lastID?: string;
  userID: number;
}

function validateAllNewsRequest() {
  return Joi.object({
    userID: Joi.number(),
    cursor: Joi.number(),
    sortBy: Joi.number().valid(
      NewsSortBy.LATEST,
      NewsSortBy.POPULAR,
      NewsSortBy.MOST_READ,
      NewsSortBy.MOST_LIKED
    ),
    sourceID: Joi.number().min(0),
    period: Joi.number().min(0).max(60),
  }).options({ stripUnknown: true });
}

async function all({
  category,
  userID,
  perPage,
  sourceID,
  lastCreatedAt,
  sortBy,
  cursor,
  period,
}: NewsRequest) {
  const values: {
    sourceID: number;
    userID: number;
    sortBy: number;
    cursor: number;
    period: number;
  } = await validateAllNewsRequest().validateAsync({
    userID,
    sourceID,
    sortBy,
    cursor,
    period,
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
      "n.like_count",
      "n.comment_count",
      "n.read_count",
    ])
    .from(`${tables.news_feed} as n`)
    .leftJoin(`${tables.news_source} as s`, "n.source_id", "s.id")
    .leftJoin(
      `${tables.news_category_alias} as ca`,
      "ca.id",
      "n.category_alias_id"
    )
    .leftJoin(`${tables.news_category} as c`, "c.id", "ca.category_id")
    .where({ "n.hidden_at": null });

  if (values.userID != null) {
    query = query
      .select(
        "bo.id as bookmark_id",
        "l.id as like_id",
        "f.id as follow_id",
        "h.id as read_history_id"
      )
      .leftJoin(`${tables.source_follow} as f`, function () {
        this.on("f.source_id", "s.id");
        this.andOnVal("f.user_id", "=", values.userID);
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
      });
  }

  // Source filter, not null sourceID should always be excluded
  if (values.sourceID != null) {
    query = query.where({ "s.id": values.sourceID });
  } else if (values.userID != null) query = query.whereNotNull("f.id");

  // Sorting period, not null sourceID should always be excluded
  if (values.period != null) {
    query = query.andWhereRaw("n.pub_date > now() - interval '??' day", [
      values.period,
    ]);
  } else if (values.sourceID == null)
    query = query.andWhereRaw("n.pub_date > now() - interval '??' day", [1]);

  //
  //
  //
  //
  // Sorting
  //
  //
  //
  //
  const weightQuery =
    "(log(n.like_count + 1) * 20000 + log(n.read_count + 1) * 40000 + extract(epoch from n.pub_date))::varchar(255)";
  if (values.sortBy == null || values.sortBy === NewsSortBy.LATEST) {
    if (lastCreatedAt != null) {
      await Joi.date().validateAsync(lastCreatedAt);
      query = query.andWhere("n.pub_date", "<", lastCreatedAt);
    }
    query = query.orderBy("n.pub_date", "desc");
  } else if (values.sortBy === NewsSortBy.MOST_LIKED) {
    if (values.cursor != null) {
      await Joi.date().required().validateAsync(lastCreatedAt);
      query = query.andWhereRaw("(n.like_count, n.pub_date) < (?,?)", [
        values.cursor,
        lastCreatedAt!,
      ]);
    }
    query = query.orderBy("n.like_count", "desc");
  } else if (values.sortBy === NewsSortBy.MOST_READ) {
    if (values.cursor != null) {
      await Joi.date().required().validateAsync(lastCreatedAt);
      query = query.andWhereRaw("(n.read_count, n.pub_date) < (?,?)", [
        values.cursor,
        lastCreatedAt!,
      ]);
    }
    query = query.orderBy("n.read_count", "desc");
  } else if (values.sortBy === NewsSortBy.POPULAR) {
    if (values.cursor != null) {
      await Joi.date().required().validateAsync(lastCreatedAt);
      query = query.andWhereRaw(`(${weightQuery}, n.pub_date) < (?,?)`, [
        values.cursor,
        lastCreatedAt!,
      ]);
    }
    query = query
      .select(db.raw(`${weightQuery} as weight`))
      .orderBy("weight", "desc");
  }
  // End of sorting

  if (category != null) {
    const val = await Joi.number().min(1).max(200).validateAsync(category);
    query = query.where((builder) => builder.where("c.id", val));
  }

  const parsedPerPage =
    Number.isNaN(Number(perPage)) === true ? DEFAULT_PERPAGE : Number(perPage);
  const limit = parsedPerPage > MAX_PERPAGE ? MAX_PERPAGE : parsedPerPage;
  query = query.limit(limit + 1);

  let news = await query;
  const hasReachedEnd = news.length !== parsedPerPage + 1;
  news = news.slice(0, parsedPerPage);

  let categories;
  if (values.cursor == null) {
    categories = await db
      .select("id", "name_en", "name_ru", "name_az", "image_suffix")
      .from(tables.news_category)
      .where({ hidden_at: null });
  }

  result = {
    news,
    categories,
    has_reached_end: hasReachedEnd,
  };

  return result;
}

async function bookmarks({ userID, perPage, lastID }: BookmarksRequest) {
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
      "n.like_count",
      "n.comment_count",
      "n.read_count",
      "bo.id as bookmark_id",
      "l.id as like_id",
      "f.id as follow_id",
      "h.id as read_history_id",
    ])
    .from(`${tables.news_feed} as n`)
    .leftJoin(`${tables.news_source} as s`, "n.source_id", "s.id")
    .leftJoin(
      `${tables.news_category_alias} as ca`,
      "ca.id",
      "n.category_alias_id"
    )
    .leftJoin(`${tables.news_category} as c`, "c.id", "ca.category_id")
    .leftJoin(`${tables.source_follow} as f`, function () {
      this.on("f.source_id", "s.id");
      this.andOnVal("f.user_id", "=", userID);
    })
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
    .whereNotNull("bo.id");

  if (lastID != null) {
    await Joi.number().validateAsync(lastID);
    query = query.andWhere("bo.id", "<", lastID);
  }
  query = query.orderBy("bo.id", "desc");

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
  const categories = await db
    .select("id", "name_en", "name_ru", "name_az", "image_suffix")
    .from(tables.news_category)
    .where({ hidden_at: null });
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
    .leftJoin(`${tables.base_user} as u`, "u.id", "c.user_id")
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
  bookmarks,
  comments,
};
