import auth from "@controllers/auth";
import {
  createResetToken,
  resetPassword,
  validateResetToken,
} from "@controllers/auth/resetToken";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.post("/login", async (req, res, next) => {
  try {
    const session = await auth.login(req.body);
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});

r.post("/register", async (req, res, next) => {
  try {
    const session = await auth.register(req.body);
    return responseContentCreated(res, session);
  } catch (e) {
    return next(e);
  }
});

r.post("/logout", authenticateMiddleware(), async (req, res, next) => {
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

r.post("/forgot-password", async (req, res, next) => {
  responseSuccess(res, {});
  try {
    await createResetToken(req.body);
    return;
  } catch (e) {
    console.log(e);
  }
});

r.post("/forgot-password/check-token", async (req, res, next) => {
  try {
    await validateResetToken(req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/reset-password", async (req, res, next) => {
  try {
    await resetPassword(req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

export default r;
