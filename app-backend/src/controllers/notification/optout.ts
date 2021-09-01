import db from "@db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import notification from "@utils/validations/notification";

const optout = async (body: any, user_id: number) => {
  const { notification_optout_type } = await notification.optout.validateAsync({
    notification_optout_type: body.notification_optout_type,
  });

  const dbOptouts = await db(tables.notification_optout).select("id").where({
    notification_optout_type,
    user_id,
  });

  if (dbOptouts.length != 0) {
    throw new SoftError(i18next.t("errors.already_optout_notification"));
  }

  await db(tables.notification_token).insert({
    notification_optout_type,
    user_id,
  });
};

export default optout;
