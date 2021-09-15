import express from "express";
import helmet from "helmet";
import routes from "@routes/index";
import adminRoutes from "@admin/routes/index";
import errorHandler from "src/middlewares/errorHandler";
import cors from "cors";

const app = express();

app.disable("x-powered-by");
app.use(express.json({ limit: "10kb" }));
app.use(helmet());

// TODO
app.use("/admin", cors({ origin: "http://localhost:3000" }), adminRoutes);
app.use(routes);

app.use(errorHandler);

export default app;
