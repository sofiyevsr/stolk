import db from "@config/db/db";
import gcAdmin from "@utils/gcadmin-sdk";
import { tables } from "@utils/constants";

import notifValidate from "@admin/utils/validations/notification";
import SoftError from "@utils/softError";
import { messaging } from "firebase-admin";

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

export const sendToEveryone = async (body: any) => {
  const { value, error } = notifValidate.message.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const tokens = await db(`${tables.notification_token} as t`)
    .select("t.token")
    .leftJoin(`${tables.notification_optout} as no`, "no.user_id", "t.user_id")
    .where({ "no.id": null });

  if (tokens.length === 0) {
    throw new SoftError("errors.empty_tokens");
  }
  const flatTokens: string[] = tokens.map(({ token }) => token);

  const res = await gcAdmin.messaging.sendMulticast({
    tokens: flatTokens,
    notification: {
      ...value,
    },
  });
  let deletedCount;
  if (res.failureCount > 0)
    deletedCount = await deleteObsoleteTokens(res.responses, flatTokens);
  return { deleted_count: deletedCount ?? 0, firebase_response: res };
};

/*
 * Send data only notif to user
 */
export const sendToUser = async (id: string, body: any) => {
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
    .leftJoin(`${tables.notification_optout} as no`, "no.user_id", "t.user_id")
    .where({ "t.user_id": id, "no.id": null });

  if (tokens.length === 0) {
    throw new SoftError("errors.empty_tokens");
  }
  const flatTokens = tokens.map(({ token }) => token);

  const res = await gcAdmin.messaging.sendMulticast({
    tokens: flatTokens,
    notification: value,
  });
  let deletedCount: number | undefined;
  if (res.failureCount > 0)
    deletedCount = await deleteObsoleteTokens(res.responses, flatTokens);
  return { deleted_count: deletedCount, firebase_response: res };
};
