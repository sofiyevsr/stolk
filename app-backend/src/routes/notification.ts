import { Router } from "express";
import notification from "@controllers/notification";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.get("/my-preferences", authenticateMiddleware(), async (req, res, next) => {
  try {
    const user_id = req.session?.user_id!;
    const data = await notification.retrieve.getAllNotificationTypesWithOptouts(
      user_id
    );
    return responseSuccess(res, data);
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
    await notification.manage.optin(req.body, user_id);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

export default r;
