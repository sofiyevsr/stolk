import db from "@db/db";
import { tables } from "@utils/constants";
import notification from "@utils/validations/notification";

export const optout = async (body: any, user_id: number) => {
  const { notification_type_id } = await notification.optout.validateAsync({
    notification_type_id: body.notification_type_id,
  });

  const dbOptouts = await db(tables.notification_optout).select("id").where({
    notification_type_id,
    user_id,
  });

  if (dbOptouts.length != 0) {
    return;
  }

  return db(tables.notification_optout).insert({
    notification_type_id,
    user_id,
  });
};

export const optin = async (body: any, user_id: number) => {
  const { notification_type_id } = await notification.optout.validateAsync({
    notification_type_id: body.notification_type_id,
  });

  return db(tables.notification_optout)
    .where({
      notification_type_id,
      user_id,
    })
    .del();
};
