import news from "@controllers/news";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.get("/all", authenticateMiddleware(true), async (req, res, next) => {
  const { limit, pub_date, categories } = req.query as {
    [key: string]: string | undefined;
  };
  try {
    const user_id = req.session?.user_id;
    const session = await news.retrieve.all(
      limit,
      pub_date,
      categories,
      user_id
    );
    return responseSuccess(res, session);
  } catch (error) {
    return next(error);
  }
});
export default r;
