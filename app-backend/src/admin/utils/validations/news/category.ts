import joi from "joi";
import i18next from "@translate/i18next";

export default joi
  .object<{
    name_ru: string;
    name_en: string;
    name_az: string;
    image_suffix: string;
  }>({
    name_az: joi
      .string()
      .required()
      .min(2)
      .messages({
        "string.base": i18next.t("errors.validation.category_name.string"),
        "string.empty": i18next.t("errors.validation.category_name.empty"),
        "string.min": i18next.t("errors.validation.category_name.min"),
        "any.required": i18next.t("errors.validation.category_name.required"),
      })
      .trim(),
    name_ru: joi
      .string()
      .required()
      .min(2)
      .messages({
        "string.base": i18next.t("errors.validation.category_name.string"),
        "string.empty": i18next.t("errors.validation.category_name.empty"),
        "string.min": i18next.t("errors.validation.category_name.min"),
        "any.required": i18next.t("errors.validation.category_name.required"),
      })
      .trim(),
    name_en: joi
      .string()
      .required()
      .min(2)
      .messages({
        "string.base": i18next.t("errors.validation.category_name.string"),
        "string.empty": i18next.t("errors.validation.category_name.empty"),
        "string.min": i18next.t("errors.validation.category_name.min"),
        "any.required": i18next.t("errors.validation.category_name.required"),
      })
      .trim(),
    image_suffix: joi
      .string()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.image_suffix.string"),
        "string.empty": i18next.t("errors.validation.image_suffix.empty"),
        "any.required": i18next.t("errors.validation.image_suffix.required"),
      })
      .trim(),
  })
  .options({ stripUnknown: true });
