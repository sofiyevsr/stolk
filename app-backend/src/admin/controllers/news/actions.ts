import db from "@config/db/db";
import { tables } from "@utils/constants";
import categoryValidation from "@admin/utils/validations/news/category";
import linkCategoryValidation from "@admin/utils/validations/news/linkCategory";
import Joi from "joi";
import SoftError from "@utils/softError";

async function hideNews(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  const [hidden_at] = await db(tables.news_feed)
    .update({ hidden_at: db.fn.now() }, ["hidden_at"])
    .where({ id: val });
  return hidden_at;
}

async function unhideNews(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  const [hidden_at] = await db(tables.news_feed)
    .update({ hidden_at: null }, ["hidden_at"])
    .where({ id: val });
  return hidden_at;
}

async function deleteComment(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.news_comment).where({ id: val }).del();
}

async function deleteCategory(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.news_category).where({ id: val }).del();
}

async function hideCategory(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  const [hidden_at] = await db(tables.news_category)
    .update({ hidden_at: db.fn.now() }, ["hidden_at"])
    .where({ id: val });
  return hidden_at;
}

async function unhideCategory(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.news_category).update({ hidden_at: null }).where({ id: val });
}

async function insertCategory(body: unknown) {
  const { error, value } = categoryValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  const [category] = await db(tables.news_category).insert(
    { name: value.name, image_suffix: value.image_suffix },
    ["id", "name", "created_at", "image_suffix", "hidden_at"]
  );
  return category;
}

async function updateCategory(body: unknown, id: unknown) {
  const val = await Joi.number().validateAsync(id);
  const { error, value } = categoryValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  const [category] = await db(tables.news_category)
    .update({ name: value.name, image_suffix: value.image_suffix }, [
      "id",
      "name",
      "created_at",
      "image_suffix",
      "hidden_at",
    ])
    .where({ id: val });
  return category;
}

async function linkCategory(body: unknown) {
  const { error, value } = linkCategoryValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  await db(tables.news_category_alias)
    .update({
      category_id: value.category_id,
    })
    .where({
      id: value.category_alias_id,
    });
}

export {
  hideNews,
  unhideNews,
  deleteComment,
  deleteCategory,
  insertCategory,
  updateCategory,
  linkCategory,
  hideCategory,
  unhideCategory,
};
