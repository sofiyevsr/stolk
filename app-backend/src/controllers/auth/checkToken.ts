import db from "@config/db/db";
import { Express } from "express";
import i18next from "@translate/i18next";
import { tables } from "@utils/constants";
import { verifyToken } from "@utils/credUtils";
import SoftError from "@utils/softError";

type UserSession = { session: Express.IUser & { id: number } };

export default async function checkToken(headers: any) {
  const authHeader = headers.authorization;
  if (authHeader == null) {
    throw new SoftError(i18next.t("errors.invalid_token"), 401);
  }
  const token = authHeader.replace("Bearer ", "");
  const decoded = await verifyToken(token);
  const session = await db
    .select(
      "s.id",
      "u.id as user_id",
      "u.first_name",
      "u.last_name",
      "u.email",
      "u.service_type_id",
      "u.created_at",
      "u.banned_at"
    )
    .from(`${tables.user_session} as s`)
    .leftJoin(`${tables.app_user} as u`, "s.user_id", "u.id")
    .where({
      "s.user_id": decoded.id,
      "s.token": token,
    });
  if (session.length === 0) {
    throw new SoftError(i18next.t("errors.invalid_token"), 401);
  }
  if (session[0].banned_at != null) {
    throw new SoftError(i18next.t("errors.account_banned"), 401);
  }
  return { user: session[0] };
}
