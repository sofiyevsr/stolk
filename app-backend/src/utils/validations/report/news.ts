import i18next from "@translate/i18next";
import joi from "joi";

export default joi
  .object<{
    message: string;
  }>({
    message: joi
      .string()
      .required()
      .max(300)
      .messages({
        "string.base": i18next.t("errors.validation.message.string"),
        "string.empty": i18next.t("errors.validation.message.empty"),
        "any.required": i18next.t("errors.validation.message.required"),
        "string.max": i18next.t("errors.validation.message.max300"),
      })
      .trim(),
  })
  .options({ stripUnknown: true });
