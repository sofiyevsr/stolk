import SoftError from "@utils/softError";
import { NextFunction, Request, Response } from "express";

export default function errorHandler(
  error: Error,
  _: Request,
  res: Response,
  next: NextFunction
) {
  if (process.env.NODE_ENV === "development") {
    if (error instanceof SoftError) {
      console.error(error.message);
      return res.status(error.code).json({ message: error.message });
    }
    if (error.message != null) {
      console.error(`core error: ${error.message}`);
      return res.status(500).json({ message: "error_occured" });
    }
  } else if (
    process.env.NODE_ENV === "staging" ||
    process.env.NODE_ENV === "production"
  ) {
    if (error instanceof SoftError) {
      return res.status(error.code).json({ message: error.message });
    }
    if (error.message != null) {
      console.error(`core error: ${error.message}`);
    }
    return res.status(500).json({ message: "error_occured" });
  }
  return res.status(500).json({ message: "error_occured" });
}
