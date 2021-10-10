import i18next from "@translate/i18next";
import SoftError from "@utils/softError";
import { NextFunction, Request, Response } from "express";

function ipExtractor(req: Request, res: Response, next: NextFunction) {
  console.log(req.headers);
  const realIP = req.headers["CF-Connecting-IP"];
  if (realIP == null)
    return next(new SoftError(i18next.t("errors.ip_unknown")));
  req.realIP = realIP as string;
  next();
}

export default ipExtractor;
