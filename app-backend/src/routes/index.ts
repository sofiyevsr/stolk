import { Router } from "express";
import auth from "./auth";
import notification from "./notification";
import news from "./news";
import source from "./source";

const r = Router();

r.use("/auth", auth);
r.use("/notification", notification);
r.use("/news", news);
r.use("/source", source);

export default r;
