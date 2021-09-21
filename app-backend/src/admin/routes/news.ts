import news from "@admin/controllers/news";
import {
  responseContentCreated,
  responseSuccess,
} from "@admin/utils/responses";
import { Router } from "express";
import authenticateMiddleware from "src/admin/middlewares/authenticate";

const r = Router();

/////////////////////////////////////////////////////
// NEWS
/////////////////////////////////////////////////////
r.get("/all", authenticateMiddleware, async (req, res, next) => {
  const { last_id } = req.query as {
    [key: string]: string | undefined;
  };
  try {
    const allNews = await news.retrieve.all(last_id);
    return responseSuccess(res, allNews);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/hide", async (req, res, next) => {
  try {
    const id = req.params.id;
    const data = await news.actions.news.hide(id);
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id/unhide", async (req, res, next) => {
  try {
    const id = req.params.id;
    const data = await news.actions.news.unhide(id);
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});
/////////////////////////////////////////////////////
// NEWS
/////////////////////////////////////////////////////
r.get("/comments", async (req, res, next) => {
  try {
    const { last_id } = req.query;
    const comments = await news.retrieve.comments(last_id as string);
    return responseSuccess(res, comments);
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

r.get("/category-aliases", async (_, res, next) => {
  try {
    const categories = await news.retrieve.allCategoryAliases();
    return responseSuccess(res, categories);
  } catch (error) {
    return next(error);
  }
});

r.patch("/category-aliases/link", async (req, res, next) => {
  try {
    const categories = await news.actions.categoryAlias.link(req.body);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.post("/category", async (req, res, next) => {
  try {
    const category = await news.actions.category.insert(req.body);
    return responseContentCreated(res, category);
  } catch (error) {
    return next(error);
  }
});

r.delete("/category/:id", async (req, res, next) => {
  try {
    const id = req.params.id;
    await news.actions.category.delete(id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.delete("/comments/:id", async (req, res, next) => {
  try {
    const id = req.params.id;
    await news.actions.comment.delete(id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
