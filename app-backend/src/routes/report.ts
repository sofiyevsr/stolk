import report from "@controllers/report";
import { parseRequest } from "@utils/commons/parseReq";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.post("/news/:id", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await report.news(id, user_id, req.body);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.post("/comment/:id", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await report.comment(id, user_id, req.body);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
