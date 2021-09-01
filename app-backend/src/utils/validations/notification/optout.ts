import joi from "joi";
import i18next from "@translate/i18next";
import { NotificationOptoutType } from "@utils/constants";

export default joi
  .object<{
    notification_optout_type: number;
  }>({
    notification_optout_type: joi
      .number()
      .required()
      .valid(NotificationOptoutType.SourceFollow)
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
