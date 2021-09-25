import db from "@config/db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

async function ban(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  const [banned_at] = await db(tables.base_user)
    .update({ banned_at: db.fn.now() }, ["banned_at"])
    .where({ id: val });
  return banned_at;
}

async function unban(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  // Banned at is object of {banned_at: string}
  const [banned_at] = await db(tables.base_user)
    .update({ banned_at: null }, ["banned_at"])
    .where({ id: val });
  return banned_at;
}

export { ban, unban };
