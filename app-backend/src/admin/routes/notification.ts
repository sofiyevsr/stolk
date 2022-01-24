import { Router } from "express";
import notification from "@admin/controllers/notification/index";
import { responseSuccess } from "@utils/responses";
import { NotificationOptoutType } from "@utils/constants";
import { parseRequest } from "@utils/commons/parseReq";

const r = Router();

r.post("/send", async (req, res, next) => {
  try {
    const data = await notification.send.sendToEveryone(
      req.body,
      NotificationOptoutType.Updates,
      "updates"
    );
    return responseSuccess(res, data);
  } catch (e) {
    return next(e);
  }
});

// Send specific news to everyone
r.post("/send-news", async (req, res, next) => {
  try {
    const { id } = await parseRequest(undefined, req.body.id);
    const data = await notification.send.sendNewsToEveryone(id);
    return responseSuccess(res, data);
  } catch (e) {
    return next(e);
  }
});

// Send to specific user
r.post("/send/:id", async (req, res, next) => {
  try {
    const data = await notification.send.sendToUser(req.params.id, req.body);
    return responseSuccess(res, data);
  } catch (e) {
    return next(e);
  }
});

export default r;
