import { Router } from "express";
import notification from "@controllers/notification/index";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.get("/fcm-topics", async (req, res, next) => {
  try {
    await notification.retrieve.getAllSubcriptions(req.body.token);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.get("/my-preferences", authenticateMiddleware(), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id!;
    await notification.retrieve.getAllNotificationTypesWithOptouts(user_id);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/save-token", authenticateMiddleware(), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id!;
    await notification.create(req.body.token, user_id);
    return responseContentCreated(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/optout", authenticateMiddleware(), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id!;
    await notification.manage.optout(req.body, user_id);
    return responseContentCreated(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/optin", authenticateMiddleware(), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id!;
    await notification.manage.optout(req.body, user_id);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

/*
// TODO apply admin permission
r.post(
  "/send",
  // authenticateMiddleware(undefined, true),
  async (req, res, next) => {
    try {
      await notification.send.sendToEveryone(req.body);
      return responseSuccess(res, {});
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
      await notification.send.sendNews(req.body);
      return responseSuccess(res);
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
      await notification.send.sendToUser(req.params.id, req.body);
      return responseSuccess(res, {});
    } catch (e) {
      return next(e);
    }
  }
);

*/
export default r;
