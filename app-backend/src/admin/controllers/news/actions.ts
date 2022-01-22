import db from "@config/db/db";
import { tables } from "@utils/constants";
import categoryValidation from "@admin/utils/validations/news/category";
import linkCategoryValidation from "@admin/utils/validations/news/linkCategory";
import Joi from "joi";
import SoftError from "@utils/softError";
import imageS3Uploader from "@admin/utils/imageS3Uploader";
import { assetsBucket } from "@admin/utils/constants";

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
  const trx = await db.transaction();
  try {
    const [categoryImg] = await trx(tables.news_category)
      .where({ id: val })
      .del()
      .returning("image_suffix");
    if (categoryImg != null)
      await imageS3Uploader.del(`category-images/${categoryImg}`, assetsBucket);
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
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

async function insertCategory(
  body: unknown,
  file: Express.Multer.File | undefined
) {
  const { error, value } = categoryValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null || file == null) {
    throw new Error();
  }
  const { name_en, name_ru, name_az } = value;

  const trx = await db.transaction();
  try {
    const [category] = await trx(tables.news_category).insert(
      { name_az, name_ru, name_en, image_suffix: value.image_suffix },
      [
        "id",
        "name_en",
        "name_ru",
        "name_az",
        "created_at",
        "image_suffix",
        "hidden_at",
      ]
    );
    await imageS3Uploader.save(
      `category-images/${value.image_suffix}`,
      assetsBucket,
      file
    );
    await trx.commit();
    return category;
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}

async function updateCategory(
  body: unknown,
  id: unknown,
  file: Express.Multer.File | undefined
) {
  const val = await Joi.number().validateAsync(id);
  const { error, value } = categoryValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null || file == null) {
    throw new Error();
  }

  const { name_en, name_ru, name_az } = value;

  const trx = await db.transaction();
  try {
    const [category] = await db(tables.news_category)
      .update(
        {
          name_az,
          name_ru,
          name_en,
          image_suffix: value.image_suffix,
        },
        [
          "id",
          "name_en",
          "name_ru",
          "name_az",
          "created_at",
          "image_suffix",
          "hidden_at",
        ]
      )
      .where({ id: val });
    await imageS3Uploader.save(
      `category-images/${value.image_suffix}`,
      assetsBucket,
      file
    );
    await trx.commit();
    return category;
  } catch (error) {
    await trx.rollback();
    throw error;
  }
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
