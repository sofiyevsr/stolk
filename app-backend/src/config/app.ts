import express from "express";
import helmet from "helmet";
import routes from "@routes/index";
import adminRoutes from "@admin/routes/index";
import errorHandler from "src/middlewares/errorHandler";
import cors from "cors";

const app = express();

app.disable("x-powered-by");
app.set("trust proxy", "loopback");
app.use(express.json({ limit: "10kb" }));
app.use(helmet());

// TODO
app.use((req, res, next) => {
  req.headers["CF-Connecting-IP"] = "0.0.0.1";
  next();
});

app.use(
  "/admin",
  cors({
    origin:
      process.env.NODE_ENV === "production"
        ? "https://flare.stolk.app"
        : "http://localhost:3000",
  }),
  adminRoutes
);
app.use(routes);

app.use(errorHandler);

export default app;
