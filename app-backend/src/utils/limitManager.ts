import db from "@config/db/db";
import i18next from "@translate/i18next";
import dayjs from "dayjs";
import {
  newCommentsBackoffCounts,
  newCommentsBackoffMinutes,
  newRegistrationBackoffCounts,
  newRegistrationBackoffMinutes,
  newFCMTokenBackoffCounts,
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

async function limitFCMTokenSave(user_id: number) {
  const userTokensCount = await db(tables.notification_token)
    .select(db.raw("count(token) as token_count"))
    .where({
      user_id,
    })
    .first();
  // Avoid users overusing route
  if (
    userTokensCount &&
    userTokensCount.token_count >= newFCMTokenBackoffCounts
  ) {
    throw new SoftError(i18next.t("errors.invalid_token"));
  }
}

export default {
  limitComment,
  limitRegister,
  limitFCMTokenSave,
};
