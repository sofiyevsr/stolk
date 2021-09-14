import request from "superagent";
import i18next from "@translate/i18next";
import SoftError from "@utils/softError";
import { NextFunction, Request, Response } from "express";

/*
 * Recaptcha v3 check
 */
export default async function Recaptchaverify(
  req: Request,
  _: Response,
  next: NextFunction
) {
  try {
    const { recaptchaToken } = req.body;
    if (recaptchaToken == null || typeof recaptchaToken !== "string") {
      throw new SoftError(i18next.t("errors.recaptcha_fail"));
    }
    const { body } = await request
      .post("https://www.google.com/recaptcha/api/siteverify")
      .send(`secret=${process.env.RECAPTCHA_SECRET_KEY}`)
      .send(`response=${recaptchaToken}`);
    if (body.success === false)
      throw new SoftError(i18next.t("errors.recaptcha_fail"));
    return next();
  } catch (err) {
    return next(err);
  }
}
