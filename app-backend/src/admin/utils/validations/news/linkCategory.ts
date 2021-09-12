import joi from "joi";
import i18next from "@translate/i18next";

export default joi
  .object<{
    category_id: number;
    category_alias_id: number;
  }>({
    category_id: joi
      .number()
      .allow(null)
      .required()
      .messages({
        "number.base": i18next.t("errors.validation.category_id.string"),
        "any.required": i18next.t("errors.validation.category_id.required"),
      }),
    category_alias_id: joi
      .number()
      .required()
      .messages({
        "number.base": i18next.t("errors.validation.category_alias_id.string"),
        "any.required": i18next.t(
          "errors.validation.category_alias_id.required"
        ),
      }),
  })
  .options({ stripUnknown: true });
