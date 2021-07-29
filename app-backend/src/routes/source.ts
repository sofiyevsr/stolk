import source from "@controllers/source";
import { parseRequest } from "@utils/commons/parseReq";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.get("/", authenticateMiddleware(true), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id;
    const data = await source.retrieve.allSources(user_id);
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/follow", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await source.actions.follow(id, user_id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/unfollow", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await source.actions.unfollow(id, user_id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
