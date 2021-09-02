import auth from "@controllers/auth/index";
import i18next from "@translate/i18next";
import SoftError from "@utils/softError";
import { NextFunction, Request, Response } from "express";

/*
 * Auth Middleware
 * @param {boolean} isOptional - prevents function to throw error
 * @param {boolean} shouldBeConfirmed - checks if user has confirmed account, doesn't override isOptional
 */
export default function authenticateMiddleware(
  isOptional = false,
  shouldBeConfirmed = false
) {
  return async function middleware(
    req: Request,
    _: Response,
    next: NextFunction
  ) {
    try {
      const { user } = await auth.checkToken(req.headers);
      if (shouldBeConfirmed === true && user.confirmed_at == null) {
        throw new SoftError(i18next.t("errors.user_not_confirmed"));
      }
      req.session = user;
      return next();
    } catch (err) {
      if (isOptional === true) return next();
      return next(err);
    }
  };
}
