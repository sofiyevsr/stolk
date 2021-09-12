import joi from "joi";
import i18next from "@translate/i18next";
import { passwordRegex } from "@utils/constants";

export default joi
  .object<{
    email: string;
    password: string;
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
  })
  .options({ stripUnknown: true });
