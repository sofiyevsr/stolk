import i18next from "@translate/i18next";
import Joi from "joi";

export async function parseRequest(
  user: number | undefined,
  entity_id: unknown
) {
  const user_id = user as number;
  const id = await Joi.number()
    .required()
    .messages({
      "number.base": i18next.t("errors.validation.id.number"),
      "any.required": i18next.t("errors.validation.id.required"),
    })
    .validateAsync(entity_id);
  return {
    user_id,
    id,
  };
}
