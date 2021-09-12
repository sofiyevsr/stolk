import db from "@config/db/db";
import { tables } from "@utils/constants";
import Joi from "joi";

async function ban(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.app_user)
    .update({ banned_at: db.fn.now() })
    .where({ id: val });
}

async function unban(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.app_user).update({ banned_at: null }).where({ id: val });
}

export { ban, unban };
