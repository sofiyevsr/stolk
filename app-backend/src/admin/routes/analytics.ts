import analytics from "@admin/controllers/analytics";
import { responseSuccess } from "@admin/utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.get("/all", authenticateMiddleware, async (_, res, next) => {
  try {
    const analyticsData = await analytics.retrieve.all();
    return responseSuccess(res, analyticsData);
  } catch (error) {
    return next(error);
  }
});

r.post("/refresh", async (_, res, next) => {
  try {
    const data = await analytics.actions.refresh();
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});
export default r;
