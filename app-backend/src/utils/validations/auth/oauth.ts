import joi from "joi";
import i18next from "@translate/i18next";

export default joi
  .object<{
    token: string;
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
  })
  .options({ stripUnknown: true });
