import db from "@config/db/db";
import gcAdmin from "@utils/gcadmin-sdk";
import { NotificationOptoutType, tables } from "@utils/constants";

import notifValidate from "@admin/utils/validations/notification";
import SoftError from "@utils/softError";
import { messaging } from "firebase-admin";
import i18next from "@translate/i18next";

enum NotificationType {
  WebViewOpen = "webview_open",
}

const highAvailibilityOptions = (
  tokens: string[],
  data: any
): messaging.MulticastMessage => ({
  tokens,
  data,
  android: {
    priority: "normal",
  },
  // Add APNS (Apple) config
  apns: {
    payload: {
      aps: {
        contentAvailable: true,
      },
    },
    headers: {
      "apns-push-type": "background",
      "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
      "apns-topic": "app.stolk.ios", // bundle identifier
    },
  },
});

const deleteObsoleteTokens = async (
  responses: messaging.SendResponse[],
  tokens: string[]
) => {
  const fails: string[] = [];
  responses.forEach((d, i) => {
    console.log(d);
    if (
      !d.success &&
      (d.error?.code === "messaging/registration-token-not-registered" ||
        d.error?.code === "messaging/invalid-registration-token")
    ) {
      fails.push(tokens[i]);
    }
  });
  if (fails.length !== 0) {
    const deletedRows = await db(tables.notification_token)
      .delete()
      .whereIn("token", tokens);
    return deletedRows;
  }
};

export const sendToEveryone = async (
  body: any,
  notificationType: NotificationOptoutType,
  tag?: string,
  data?: any
) => {
  const { value, error } = notifValidate.message.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const tokens = await db
    .select("t.token")
    .from(`${tables.notification_token} as t`)
    .leftJoin(`${tables.user_session} as us`, "us.id", "t.session_id")
    .leftJoin(`${tables.notification_optout} as no`, function () {
      this.on("no.user_id", "us.user_id");
      this.andOnVal("no.notification_type_id", "=", notificationType);
    })
    .where({ "no.id": null });

  if (tokens.length === 0) {
    throw new SoftError(i18next.t("errors.empty_tokens"));
  }
  const flatTokens: string[] = tokens.map(({ token }) => token);

  const res = await gcAdmin.messaging.sendMulticast({
    tokens: flatTokens,
    data: data,
    android: {
      notification: {
        tag,
      },
    },
    apns: { payload: { aps: { threadId: tag } } },
    notification: {
      ...value,
    },
  });
  let deletedCount;
  if (res.failureCount > 0)
    deletedCount = await deleteObsoleteTokens(res.responses, flatTokens);
  return {
    deleted_count: deletedCount ?? 0,
    success_count: res.successCount,
    failure_count: res.failureCount,
  };
};

export const sendNewsToEveryone = async (id: number) => {
  const [news] = await db(`${tables.news_feed} as n`)
    .select("n.title as title", "n.feed_link")
    .where({ "n.id": id });
  if (news == null) throw new SoftError(i18next.t("errors.news_not_found"));
  const data = await sendToEveryone(
    { title: "Günün xəbəri", body: news.title },
    NotificationOptoutType.SuggestedNews,
    "suggested_news",
    {
      type: NotificationType.WebViewOpen,
      link: news.feed_link,
    }
  );
  return data;
};
/*
 * Send data only notif to user
 */
export const sendToUser = async (id: string, body: any, tag?: string) => {
  const { value, error } = notifValidate.message.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const parsedID = Number.parseInt(id);
  if (Number.isNaN(parsedID) === true) {
    throw new SoftError("errors.invalid_id");
  }
  const tokens = await db
    .select("t.token")
    .from(`${tables.notification_token} as t`)
    .leftJoin(`${tables.user_session} as us`, "us.id", "t.session_id")
    .leftJoin(`${tables.notification_optout} as no`, "no.user_id", "us.user_id")
    .where({ "us.user_id": id, "no.id": null });

  if (tokens.length === 0) {
    throw new SoftError(i18next.t("errors.empty_tokens"));
  }
  const flatTokens = tokens.map(({ token }) => token);

  const res = await gcAdmin.messaging.sendMulticast({
    tokens: flatTokens,
    android: {
      notification: {
        tag,
      },
    },
    apns: { payload: { aps: { threadId: tag } } },
    notification: value,
  });
  let deletedCount: number | undefined;
  if (res.failureCount > 0)
    deletedCount = await deleteObsoleteTokens(res.responses, flatTokens);
  return {
    deleted_count: deletedCount ?? 0,
    success_count: res.successCount,
    failure_count: res.failureCount,
  };
};
