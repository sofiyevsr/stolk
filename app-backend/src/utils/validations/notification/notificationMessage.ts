import i18next from "@translate/i18next";
import joi from "joi";

export default joi.object<{
  title: string;
  body: string;
}>({
  title: joi
    .string()
    .required()
    .max(20)
    .messages({
      "string.base": i18next.t("errors.validation.title.string"),
      "string.empty": i18next.t("errors.validation.title.empty"),
      "any.required": i18next.t("errors.validation.title.required"),
      "string.max": i18next.t("errors.validation.title.max20"),
    })
    .trim(),
  body: joi
    .string()
    .required()
    .max(100)
    .messages({
      "string.base": i18next.t("errors.validation.body.string"),
      "string.empty": i18next.t("errors.validation.body.empty"),
      "any.required": i18next.t("errors.validation.body.required"),
      "string.max": i18next.t("errors.validation.body.max20"),
    })
    .trim(),
});
