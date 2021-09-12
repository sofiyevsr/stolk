import { PAGINATION_LIMIT } from "@admin/utils/constants";
import db from "@db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

const news = async (lastID: string | undefined) => {
  let query = db
    .select(
      "r.id",
      "n.id as news_id",
      "n.title",
      "n.source_id",
      "n.feed_link",
      "n.image_link",
      "r.message",
      "u.id as reporter_id",
      db.raw("(u.first_name || ' ' || u.last_name) as reporter_full_name")
    )
    .from(`${tables.news_report} as nr`)
    .leftJoin(`${tables.report} as r`, "nr.report_id", "r.id")
    .leftJoin(`${tables.app_user} as u`, "nr.user_id", "u.id")
    .leftJoin(`${tables.news_feed} as n`, "nr.news_id", "n.id")
    .orderBy("nr.report_id", "desc")
    .limit(PAGINATION_LIMIT);
  if (lastID != null) {
    const id = await Joi.date().validateAsync(lastID);
    query = query.andWhere("nr.report_id", "<", id);
  }
  const reports = await query;
  return reports;
};

const comments = async (lastID: string | undefined) => {
  let query = db
    .select(
      "r.id",
      "c.id as comment_id",
      "r.message",
      "c.comment",
      "c.id as comment_id",
      "cu.id as commenter_id",
      "u.id as reporter_id",
      db.raw("(u.first_name || ' ' || u.last_name) as reporter_full_name"),
      db.raw("(cu.first_name || ' ' || cu.last_name) as commenter_full_name")
    )
    .from(`${tables.comment_report} as cr`)
    .leftJoin(`${tables.report} as r`, "cr.report_id", "r.id")
    .leftJoin(`${tables.app_user} as u`, "cr.user_id", "u.id")
    .leftJoin(`${tables.news_comment} as c`, "cr.comment_id", "c.id")
    .leftJoin(`${tables.app_user} as cu`, "c.user_id", "cu.id")
    .orderBy("cr.report_id", "desc")
    .limit(PAGINATION_LIMIT);
  if (lastID != null) {
    const id = await Joi.date().validateAsync(lastID);
    query = query.andWhere("cr.report_id", "<", id);
  }
  const reports = await query;
  return reports;
};

export default { news, comments };
