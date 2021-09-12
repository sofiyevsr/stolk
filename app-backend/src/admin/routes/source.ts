import source from "@admin/controllers/source";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.get("/", authenticateMiddleware, async (req, res, next) => {
  try {
    const data = await source.retrieve.allSources();
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});
export default r;
