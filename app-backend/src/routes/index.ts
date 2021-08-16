import { Router } from "express";
import auth from "./auth";
import notification from "./notification";
import news from "./news";
import source from "./source";
import report from "./report";

const r = Router();

r.use("/auth", auth);
r.use("/notification", notification);
r.use("/news", news);
r.use("/source", source);
r.use("/report", report);

export default r;
