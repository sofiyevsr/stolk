import i18next from "@translate/i18next";
import joi from "joi";

export default joi
  .object<{
    comment: string;
  }>({
    comment: joi
      .string()
      .required()
      .max(300)
      .messages({
        "string.base": i18next.t("errors.validation.comment.string"),
        "string.empty": i18next.t("errors.validation.comment.empty"),
        "any.required": i18next.t("errors.validation.comment.required"),
        "string.max": i18next.t("errors.validation.comment.max300"),
      })
      .trim(),
  })
  .options({ stripUnknown: true });
