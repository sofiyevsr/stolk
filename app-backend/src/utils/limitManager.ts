import db from "@config/db/db";
import i18next from "@translate/i18next";
import dayjs from "dayjs";
import {
  newCommentsBackoffCounts,
  newCommentsBackoffMinutes,
  newRegistrationBackoffCounts,
  newRegistrationBackoffMinutes,
  tables,
} from "./constants";
import SoftError from "./softError";

async function limitRegister(ip: string) {
  const users = await db
    .select(["created_at"])
    .from(tables.base_user)
    .where({ ip_address: ip })
    .orderBy("id", "desc")
    .limit(newRegistrationBackoffCounts);
  if (users.length < newRegistrationBackoffCounts) {
    return;
  }
  for (const user of users) {
    const createdAt = dayjs(user.created_at);
    const difference = dayjs().diff(createdAt, "minute");
    // if one of them if older than backoff minutes then we are good to go
    if (difference > newRegistrationBackoffMinutes) {
      return;
    }
  }
  throw new SoftError(i18next.t("errors.backoff_register"));
}

async function limitComment(ip: string) {
  const comments = await db
    .select(["created_at"])
    .from(tables.news_comment)
    .where({ ip_address: ip })
    .orderBy("id", "desc")
    .limit(newCommentsBackoffCounts);
  if (comments.length < newCommentsBackoffCounts) {
    return;
  }
  for (const comment of comments) {
    const createdAt = dayjs(comment.created_at);
    const difference = dayjs().diff(createdAt, "minute");
    // if one of them if older than backoff minutes then we are good to go
    if (difference > newCommentsBackoffMinutes) {
      return;
    }
  }
  throw new SoftError(i18next.t("errors.backoff_comment"));
}

export default {
  limitComment,
  limitRegister,
};
