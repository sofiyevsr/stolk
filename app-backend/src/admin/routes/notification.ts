import { Router } from "express";
import notification from "@admin/controllers/notification/index";
import { responseSuccess } from "@utils/responses";

const r = Router();

r.post("/send", async (req, res, next) => {
  try {
    const data = await notification.send.sendToEveryone(req.body);
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
