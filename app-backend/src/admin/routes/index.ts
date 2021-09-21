import { Router } from "express";
import auth from "./auth";
import notification from "./notification";
import news from "./news";
import source from "./source";
import report from "./report";
import users from "./user";
import analytics from "./analytics";

const r = Router();

r.use("/auth", auth);
r.use("/notification", notification);
r.use("/news", news);
r.use("/source", source);
r.use("/report", report);
r.use("/users", users);
r.use("/analytics", analytics);

export default r;
