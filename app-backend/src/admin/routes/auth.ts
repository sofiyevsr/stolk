import auth from "@admin/controllers/auth";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

r.post("/login", async (req, res, next) => {
  try {
    const session = await auth.login(req.body);
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});

r.post("/logout", authenticateMiddleware, async (req, res, next) => {
  try {
    const session = await auth.logout(req.session?.id);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/check-token", async (req, res, next) => {
  try {
    const user = await auth.checkToken(req.headers);
    return responseSuccess(res, user);
  } catch (e) {
    return next(e);
  }
});

export default r;
