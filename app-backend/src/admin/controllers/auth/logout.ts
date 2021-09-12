import db from "@config/db/db";
import { tables } from "@utils/constants";

async function logout(session_id?: number) {
  await db(tables.admin_user).update({ token: null }).where({ id: session_id });
}

export default logout;
