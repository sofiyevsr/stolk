import { Router } from "express";
import auth from "./auth";
import notification from "./notification";
import news from "./news";

const r = Router();

r.use("/auth", auth);
r.use("/notification", notification);
r.use("/news", news);

export default r;
