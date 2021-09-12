import db from "@config/db/db";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import { verifyToken } from "@admin/utils/credUtils";
import SoftError from "@utils/softError";

type UserSession = { session: Express.IAdmin };

export default async function checkToken(headers: any) {
  const authHeader = headers.authorization;
  if (authHeader == null) {
    throw new SoftError(i18next.t("errors.invalid_token"), 401);
  }
  const token = authHeader.replace("Bearer ", "");
  const decoded = await verifyToken(token);
  const session = await db
    .select("u.id", "u.first_name", "u.last_name", "u.email", "u.created_at")
    .from(`${tables.admin_user} as u`)
    .where({
      "u.id": decoded.id,
      "u.token": token,
    });
  if (session.length === 0) {
    throw new SoftError(i18next.t("errors.invalid_token"), 401);
  }

  return { user: session[0] };
}
