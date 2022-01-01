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

r.post("/", async (req, res, next) => {
  try {
    await source.actions.insert(req.body);
    return responseSuccess(res);
  } catch (error) {
    return next(error);
  }
});

export default r;
