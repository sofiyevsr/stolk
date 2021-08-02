import news from "@controllers/news";
import { parseRequest } from "@utils/commons/parseReq";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/middlewares/authenticate";

const r = Router();

r.get("/all", authenticateMiddleware(true), async (req, res, next) => {
  const { limit, pub_date, source_id, category, filter_by } = req.query as {
    [key: string]: string | undefined;
  };
  try {
    const user_id = req.session?.user_id;
    const allNews = await news.retrieve.all(
      limit,
      pub_date,
      category,
      user_id,
      source_id,
      filter_by
    );
    return responseSuccess(res, allNews);
  } catch (error) {
    return next(error);
  }
});

r.get("/categories", async (_, res, next) => {
  try {
    const categories = await news.retrieve.allCategories();
    return responseSuccess(res, categories);
  } catch (error) {
    return next(error);
  }
});

r.get("/:id/comments", async (req, res, next) => {
  try {
    const { id } = await parseRequest(undefined, req.params.id);
    const { last_id } = req.query;
    const comments = await news.retrieve.comments(id, last_id as string);
    return responseSuccess(res, comments);
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/comment", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    const comment = await news.actions.comment(id, user_id, req.body);
    return responseSuccess(res, { comment });
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/bookmark", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    const bookmark_id = await news.actions.bookmark(id, user_id);
    return responseSuccess(res, { bookmark_id });
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/unbookmark", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await news.actions.unbookmark(id, user_id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/like", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    const like_id = await news.actions.like(id, user_id);
    return responseSuccess(res, { like_id });
  } catch (error) {
    return next(error);
  }
});

r.post("/:id/unlike", authenticateMiddleware(), async (req, res, next) => {
  try {
    const { user_id, id } = await parseRequest(
      req.session?.user_id,
      req.params.id
    );
    await news.actions.unlike(id, user_id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
