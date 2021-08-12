import express from "express";
import helmet from "helmet";
import routes from "@routes/index";
import errorHandler from "src/middlewares/errorHandler";

const app = express();

app.disable("x-powered-by");
app.use(express.json({ limit: "10kb" }));
app.use(helmet());

app.use(routes);

app.use(errorHandler);

export default app;
