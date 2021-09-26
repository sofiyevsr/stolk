import joi from "joi";
import i18next from "@translate/i18next";
import { passwordRegex, ServiceType, SessionType } from "@utils/constants";

export default joi
  .object<{
    email: string;
    password: string;
    session_type: number;
  }>({
    email: joi
      .string()
      .email()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.email.string"),
        "string.empty": i18next.t("errors.validation.email.empty"),
        "any.required": i18next.t("errors.validation.email.required"),
        "string.email": i18next.t("errors.validation.email.invalid_email"),
      })
      .trim(),
    password: joi
      .string()
      .pattern(passwordRegex)
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.password.string"),
        "string.empty": i18next.t("errors.validation.password.empty"),
        "any.required": i18next.t("errors.validation.password.required"),
        "string.pattern.base": i18next.t(
          "errors.validation.password.invalid_pattern"
        ),
      }),
    // service_type: joi
    //   .number()
    //   .required()
    //   .valid(ServiceType.APP)
    //   .messages({
    //     "number.base": i18next.t("errors.validation.service_type.number"),
    //     "any.required": i18next.t("errors.validation.service_type.required"),
    //     "any.only": i18next.t("errors.validation.service_type.invalid"),
    //   }),

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
