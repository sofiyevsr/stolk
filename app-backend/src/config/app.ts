import express from "express";
import helmet from "helmet";
import routes from "@routes/index";
import adminRoutes from "@admin/routes/index";
import errorHandler from "src/middlewares/errorHandler";
import cors from "cors";
import morgan from "morgan";

const app = express();

app.disable("x-powered-by");
app.set("trust proxy", "loopback");
app.use(express.json({ limit: "10kb" }));
app.use(helmet());

// TODO
if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
  app.use((req, res, next) => {
    req.headers["cf-connecting-ip"] = "0.0.0.1";
    next();
  });
}

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
