import joi from "joi";
import i18next from "@translate/i18next";

const createResetToken = joi
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

const resetPassword = joi
  .object<{
    id: number;
    token: string;
    password: string;
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
      })
      .trim(),
    password: joi
      .string()
      .pattern(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/)
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

const validateToken = joi
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

export default { validateToken, resetPassword, createResetToken };
