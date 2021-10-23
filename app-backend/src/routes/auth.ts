import auth from "@controllers/auth";
import {
  createConfirmationToken,
  verifyEmail,
} from "@controllers/auth/confirmationToken";
import oauth from "@controllers/auth/oauth";
import {
  createResetToken,
  resetPassword,
  validateResetToken,
} from "@controllers/auth/resetToken";
import limitManager from "@utils/limitManager";
import { responseContentCreated, responseSuccess } from "@utils/responses";
import cors from "cors";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";
import ipExtractor from "src/middlewares/ipExtractor";

const isProd = process.env.NODE_ENV === "production";
const r = Router();

r.use(cors({ origin: isProd ? "https://stolk.app" : "http://localhost:3000" }));

r.use(ipExtractor);

r.post("/login", async (req, res, next) => {
  try {
    const session = await auth.login(req.body, req.realIP);
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});

r.post("/login/google", async (req, res, next) => {
  try {
    const session = await oauth.googleLoginUser(req.body, req.realIP);
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});

r.post("/login/facebook", async (req, res, next) => {
  try {
    const session = await oauth.facebookLoginUser(req.body, req.realIP);
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});

r.post("/register", async (req, res, next) => {
  try {
    await limitManager.limitRegister(req.realIP);
    const session = await auth.register(req.body, req.realIP);
    return responseContentCreated(res, session);
  } catch (e) {
    return next(e);
  }
});

r.post("/logout", authenticateMiddleware(), async (req, res, next) => {
  try {
    const session = await auth.logout(
      req.session?.id,
      req.session?.user_id,
      req.body.token
    );
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

r.post("/forgot-password", async (req, res, _) => {
  responseSuccess(res, {});
  try {
    await createResetToken(req.body);
  } catch (e) {}
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

r.post("/verify-email", async (req, res, next) => {
  try {
    await verifyEmail(req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post("/email-verification", async (req, res, next) => {
  try {
    await createConfirmationToken(req.body);
    return responseSuccess(res, {});
  } catch (e) {
    return next(e);
  }
});

r.post(
  "/complete-profile",
  authenticateMiddleware(),
  async (req, res, next) => {
    try {
      const data = await auth.completeProfile(req.session?.user_id!);
      return responseSuccess(res, data);
    } catch (e) {
      return next(e);
    }
  }
);
export default r;
