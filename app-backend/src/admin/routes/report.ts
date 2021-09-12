import report from "@admin/controllers/report";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.get("/news", authenticateMiddleware, async (req, res, next) => {
  try {
    const { last_id } = req.query;
    const reports = await report.news(last_id as string);
    return responseSuccess(res, reports);
  } catch (error) {
    return next(error);
  }
});

r.get("/comments", authenticateMiddleware, async (req, res, next) => {
  try {
    const { last_id } = req.query;
    const reports = await report.comments(last_id as string);
    return responseSuccess(res, reports);
  } catch (error) {
    return next(error);
  }
});

export default r;
