import db from "@config/db/db";
import app from "@utils/gcadmin-sdk";
import { AccountType, notification_topics, tables } from "@utils/constants";

import notifValidate from "@utils/validations/notification";
import SoftError from "@utils/softError";
import { messaging } from "firebase-admin";

const highAvailibilityOptions = (
  tokens: string[],
  data: any
): messaging.MulticastMessage => ({
  tokens,
  data,
  android: {
    priority: "high",
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
      "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
    },
  },
});

const deleteObsoleteTokens = async (
  responses: messaging.SendResponse[],
  tokens: string[]
) => {
  const fails: string[] = [];
  responses.forEach((d, i) => {
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
    if (deletedRows === 0) {
      throw new SoftError("errors.no_token_deleted");
    }
  }
};
export const sendToEveryone = async (body: any) => {
  const { value, error } = notifValidate.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  let tokens = await db(tables.notification_token).select("token");
  tokens = tokens.map((to) => to.token);

  if (tokens.length === 0) {
    throw new SoftError("errors.empty_tokens");
  }

  const res = await app.messaging().sendMulticast({
    tokens,
    notification: {
      ...value,
    },
  });
  if (res.failureCount > 0) deleteObsoleteTokens(res.responses, tokens);
};

export const sendToSegmentUsers = async (body: any, segment: AccountType) => {
  const { value, error } = notifValidate.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const tokens = await db(`${tables.notification_token} as t`)
    .select("token")
    .leftJoin(`${tables.app_user} as u`, "u.id", "t.user_id")
    .where({ "u.account_type": segment });
  if (tokens.length === 0) {
    throw new SoftError("errors.empty_tokens");
  }

  const res = await app.messaging().sendMulticast({
    tokens,
    notification: {
      ...value,
    },
  });
  if (res.failureCount > 0) deleteObsoleteTokens(res.responses, tokens);
};

export const sendNews = async (body: any) => {
  const { value, error } = notifValidate.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  await app
    .messaging()
    .sendToTopic(notification_topics.news, { notification: value });
};

/*
 * Send data only notif to user
 * This has to be translated on app
 */
export const sendToUser = async (id: string, body: any) => {
  const { value, error } = notifValidate.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const parsedID = Number.parseInt(id, 10);
  if (Number.isNaN(parsedID) === true) {
    throw new SoftError("errors.invalid_id");
  }
  const tokens = await db(`${tables.notification_token} as t`)
    .select("token")
    .where({ "u.id": id });

  if (tokens.length === 0) {
    throw new SoftError("errors.empty_tokens");
  }

  const res = await app.messaging().sendMulticast({
    tokens,
    notification: value,
  });
  if (res.failureCount > 0) deleteObsoleteTokens(res.responses, tokens);
};
