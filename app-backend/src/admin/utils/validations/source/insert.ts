import joi from "joi";
import i18next from "@translate/i18next";
import { langs } from "@utils/dbData";

export default joi
  .object<{
    lang_id: number;
    logo_suffix: string;
    name: string;
    link: string;
    category_alias_name: string;
  }>({
    name: joi
      .string()
      .required()
      .min(2)
      .max(20)
      .messages({
        "string.base": i18next.t("errors.validation.name.string"),
        "string.empty": i18next.t("errors.validation.name.empty"),
        "string.min": i18next.t("errors.validation.name.min"),
        "string.max": i18next.t("errors.validation.name.max"),
        "any.required": i18next.t("errors.validation.name.required"),
      })
      .trim(),
    category_alias_name: joi
      .string()
      .required()
      .min(2)
      .max(20)
      .messages({
        "string.base": i18next.t(
          "errors.validation.category_alias_name.string"
        ),
        "string.empty": i18next.t(
          "errors.validation.category_alias_name.empty"
        ),
        "string.min": i18next.t("errors.validation.category_alias_name.min"),
        "string.max": i18next.t("errors.validation.category_alias_name.max"),
        "any.required": i18next.t(
          "errors.validation.category_alias_name.required"
        ),
      })
      .trim(),
    logo_suffix: joi
      .string()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.logo_suffix.string"),
        "string.empty": i18next.t("errors.validation.logo_suffix.empty"),
        "any.required": i18next.t("errors.validation.logo_suffix.required"),
      })
      .trim(),
    link: joi
      .string()
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.link.string"),
        "string.empty": i18next.t("errors.validation.link.empty"),
        "any.required": i18next.t("errors.validation.link.required"),
      })
      .trim(),
    lang_id: joi
      .number()
      .required()
      .valid(langs.map((l) => l.id))
      .messages({
        "number.base": i18next.t("errors.validation.lang_id.number"),
        "any.required": i18next.t("errors.validation.lang_id.required"),
        "any.only": i18next.t("errors.validation.lang_id.invalid"),
      }),
  })
  .options({ stripUnknown: true });
