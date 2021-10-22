import { Router } from "express";
import notification from "@admin/controllers/notification/index";
import { responseSuccess } from "@utils/responses";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.post("/send", authenticateMiddleware, async (req, res, next) => {
  try {
    await notification.send.sendToEveryone(req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

// Send to specific user
r.post("/send/:id", authenticateMiddleware, async (req, res, next) => {
  try {
    await notification.send.sendToUser(req.params.id, req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

export default r;
