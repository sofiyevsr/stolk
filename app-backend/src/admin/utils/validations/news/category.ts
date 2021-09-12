import joi from "joi";
import i18next from "@translate/i18next";

export default joi
  .object<{
    name: string;
  }>({
    name: joi
      .string()
      .allow(null)
      .required()
      .messages({
        "string.base": i18next.t("errors.validation.category_name.string"),
        "string.empty": i18next.t("errors.validation.category_name.empty"),
        "any.required": i18next.t("errors.validation.category_name.required"),
      })
      .trim(),
  })
  .options({ stripUnknown: true });
