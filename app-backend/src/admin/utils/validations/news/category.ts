import joi from "joi";
import i18next from "@translate/i18next";

export default joi
  .object<{
    name: string;
  }>({
    name: joi
      .string()
      .required()
      .min(2)
      .max(8)
      .messages({
        "string.base": i18next.t("errors.validation.category_name.string"),
        "string.empty": i18next.t("errors.validation.category_name.empty"),
        "string.min": i18next.t("errors.validation.category_name.min"),
        "string.max": i18next.t("errors.validation.category_name.max"),
        "any.required": i18next.t("errors.validation.category_name.required"),
      })
      .trim(),
  })
  .options({ stripUnknown: true });
