import source from "@admin/controllers/source";
import { responseSuccess } from "@utils/responses";
import { Router } from "express";

const r = Router();

r.get("/", async (req, res, next) => {
  try {
    const data = await source.retrieve.allSources();
    return responseSuccess(res, data);
  } catch (error) {
    return next(error);
  }
});

r.delete("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    await source.actions.delete(id);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

r.patch("/:id", async (req, res, next) => {
  try {
    const { id } = req.params;
    const updatedSource = await source.actions.update(req.body, id);
    return responseSuccess(res, updatedSource);
  } catch (error) {
    return next(error);
  }
});

r.post("/", async (req, res, next) => {
  try {
    const createdSource = await source.actions.insert(req.body);
    return responseSuccess(res, createdSource);
  } catch (error) {
    return next(error);
  }
});

export default r;
