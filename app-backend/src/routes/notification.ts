import { Router } from "express";
import notification from "@controllers/notification/index";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.post(
  "/save-token",
  // authenticateMiddleware(undefined, true),
  async (req, res, next) => {
    try {
      const user_id = req.session?.user_id;
      const data = await notification.create(req.body.token, user_id);
      return responseContentCreated(res, data);
    } catch (e) {
      return next(e);
    }
  }
);

// TODO apply admin permission
r.post(
  "/send",
  // authenticateMiddleware(undefined, true),
  async (req, res, next) => {
    try {
      const data = await notification.send.sendToEveryone(req.body);
      return responseSuccess(res, data);
    } catch (e) {
      return next(e);
    }
  }
);

r.post(
  "/send/news",
  // authenticateMiddleware(undefined, true),
  async (req, res, next) => {
    try {
      const data = await notification.send.sendNews(req.body);
      return responseSuccess(res, data);
    } catch (e) {
      return next(e);
    }
  }
);
r.post(
  "/send/:id",
  // authenticateMiddleware(undefined, true),
  async (req, res, next) => {
    try {
      const data = await notification.send.sendToUser(req.params.id, req.body);
      return responseSuccess(res, data);
    } catch (e) {
      return next(e);
    }
  }
);

export default r;
