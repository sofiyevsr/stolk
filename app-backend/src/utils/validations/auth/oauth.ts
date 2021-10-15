import joi from "joi";
import i18next from "@translate/i18next";
import { SessionType } from "@utils/constants";

export default joi
  .object<{
    token: string;
    session_type: number;
  }>({
    token: joi
      .string()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.token.string"),
        "string.empty": i18next.t("errors.validation.token.empty"),
        "any.required": i18next.t("errors.validation.token.required"),
      })
      .trim(),
    session_type: joi
      .number()
      .required()
      .valid(SessionType.IOS, SessionType.ANDROID)
      .messages({
        "number.base": i18next.t("errors.validation.session_type.number"),
        "any.required": i18next.t("errors.validation.session_type.required"),
        "any.only": i18next.t("errors.validation.session_type.invalid"),
      }),
  })
  .options({ stripUnknown: true });
