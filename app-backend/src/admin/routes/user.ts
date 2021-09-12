import user from "@admin/controllers/user";
import { responseSuccess } from "@admin/utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.get("/", authenticateMiddleware, async (req, res, next) => {
  try {
    const { last_id } = req.query as {
      [key: string]: string | undefined;
    };
    const data = await user.retrieve.users(last_id);
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/ban", authenticateMiddleware, async (req, res, next) => {
  try {
    const id = req.params.id;
    await user.actions.ban(id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/unban", authenticateMiddleware, async (req, res, next) => {
  try {
    const id = req.params.id;
    await user.actions.unban(id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
