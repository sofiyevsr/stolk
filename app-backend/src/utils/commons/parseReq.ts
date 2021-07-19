import Joi from "joi";

export async function parseRequest(
  user: number | undefined,
  entity_id: unknown
) {
  const user_id = user as number;
  const id = await Joi.number().required().validateAsync(entity_id);
  return {
    user_id,
    id,
  };
}
