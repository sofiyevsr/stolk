import joi from "joi";
import i18next from "@translate/i18next";
import { NotificationOptoutType } from "@utils/constants";

export default joi
  .object<{
    notification_type_id: number;
  }>({
    notification_type_id: joi
      .number()
      .required()
      .valid(
        NotificationOptoutType.SuggestedNews,
        NotificationOptoutType.Updates
      )
      .messages({
        "number.base": i18next.t(
          "errors.validation.notification_optout_type.number"
        ),
        "any.required": i18next.t(
          "errors.validation.notification_optout_type.required"
        ),
        "any.only": i18next.t(
          "errors.validation.notification_optout_type.invalid"
        ),
      }),
  })
  .options({ stripUnknown: true });
