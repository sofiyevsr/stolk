import joi from "joi";
import i18next from "@translate/i18next";

const createConfirmationToken = joi
  .object<{
    email: string;
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
  })
  .options({ stripUnknown: true });

const validateConfirmationToken = joi
  .object<{
    id: string;
    token: string;
  }>({
    id: joi
      .number()
      .required()
      .messages({
        "number.base": i18next.t("errors.validation.id.number"),
        "any.required": i18next.t("errors.validation.id.required"),
      }),
    token: joi
      .string()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.token.string"),
        "string.empty": i18next.t("errors.validation.token.empty"),
        "any.required": i18next.t("errors.validation.token.required"),
      }),
  })
  .options({ stripUnknown: true });

export default { createConfirmationToken, validateConfirmationToken };
