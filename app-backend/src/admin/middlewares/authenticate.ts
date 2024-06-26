import auth from "@admin/controllers/auth/index";
import { NextFunction, Request, Response } from "express";

/*
 * Admin Auth Middleware
 */
export default async function authenticateAdminMiddleware(
  req: Request,
  _: Response,
  next: NextFunction
) {
  try {
    const { user } = await auth.checkToken(req.headers);
    req.adminSession = user;
    return next();
  } catch (err) {
    return next(err);
  }
}
