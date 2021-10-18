import db from "@config/db/db";
import { tables } from "@utils/constants";

async function completeProfile(user_id: number) {
  const [user] = await db(tables.base_user)
    .update("completed_at", db.fn.now(), ["completed_at"])
    .where({ id: user_id });
  return { completed_at: user.completed_at };
}

export default completeProfile;
