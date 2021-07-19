import joi from "joi";
import i18next from "@translate/i18next";
import { passwordRegex, ServiceType, SessionType } from "@utils/constants";

export default joi
  .object<{
    first_name: string;
    last_name: string;
    password: string;
    service_type: number;
    session_type: number;
    email: string;
  }>({
    first_name: joi
      .string()
      .min(2)
      .max(30)
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.first_name.string"),
        "string.empty": i18next.t("errors.validation.first_name.empty"),
        "any.required": i18next.t("errors.validation.first_name.required"),
        "string.min": i18next.t("errors.validation.first_name.min2"),
        "string.max": i18next.t("errors.validation.first_name.max30"),
      })
      .trim(),
    last_name: joi
      .string()
      .min(2)
      .max(30)
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.last_name.string"),
        "string.empty": i18next.t("errors.validation.last_name.empty"),
        "any.required": i18next.t("errors.validation.last_name.required"),
        "string.min": i18next.t("errors.validation.last_name.min2"),
        "string.max": i18next.t("errors.validation.last_name.max30"),
      })
      .trim(),
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
    service_type: joi
      .number()
      .required()
      .valid(ServiceType.APP)
      .messages({
        "number.base": i18next.t("errors.validation.service_type.number"),
        "any.required": i18next.t("errors.validation.service_type.required"),
        "any.only": i18next.t("errors.validation.service_type.invalid"),
      }),
    session_type: joi
      .number()
      .required()
      .valid(SessionType.IOS, SessionType.ANDROID)
      .messages({
        "number.base": i18next.t("errors.validation.session_type.number"),
        "any.required": i18next.t("errors.validation.session_type.required"),
        "any.only": i18next.t("errors.validation.session_type.invalid"),
      }),
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
  })
  .options({ stripUnknown: true });
