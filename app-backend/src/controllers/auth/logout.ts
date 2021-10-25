import db from "@config/db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";

async function logout(session_id?: number) {
  if (session_id == null) {
    throw new SoftError(i18next.t("errors.invalid_session_id"));
  }
  const deletedSession = await db(tables.user_session)
    .where({ id: session_id })
    .del();
}

export default logout;
