import auth from "@controllers/auth/index";
import { NextFunction, Request, Response } from "express";

export default function authenticateMiddleware(isOptional = false) {
  return async function middleware(
    req: Request,
    _: Response,
    next: NextFunction
  ) {
    try {
      const { user } = await auth.checkToken(req.headers);
      req.session = user;
      return next();
    } catch (err) {
      if (isOptional === true) return next();
      return next(err);
    }
  };
}
