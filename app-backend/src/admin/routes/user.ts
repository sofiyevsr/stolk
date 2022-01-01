import user from "@admin/controllers/user";
import { responseSuccess } from "@admin/utils/responses";
import { Router } from "express";

const r = Router();

r.get("/", async (req, res, next) => {
  try {
    const { last_id } = req.query as {
      [key: string]: string | undefined;
    };
    const data = await user.retrieve.all(last_id);
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/ban", async (req, res, next) => {
  try {
    const id = req.params.id;
    const ban = await user.actions.ban(id);
    return responseSuccess(res, ban);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/unban", async (req, res, next) => {
  try {
    const id = req.params.id;
    const unban = await user.actions.unban(id);
    return responseSuccess(res, unban);
  } catch (error) {
    return next(error);
  }
});

export default r;
