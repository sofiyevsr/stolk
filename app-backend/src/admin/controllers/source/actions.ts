import db from "@config/db/db";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import sourceValidation from "@admin/utils/validations/source/insert";
import Joi from "joi";
import imageS3Uploader from "@admin/utils/imageS3Uploader";
import { assetsBucket } from "@admin/utils/constants";

async function insert(body: unknown, file: Express.Multer.File | undefined) {
  const { error, value } = sourceValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null || file == null) {
    throw new Error();
  }

  const trx = await db.transaction();
  try {
    const [source] = await db(tables.news_source).insert(
      {
        lang_id: value.lang_id,
        logo_suffix: value.logo_suffix,
        name: value.name,
        link: value.link,
        category_alias_name: value.category_alias_name,
      },
      [
        "id",
        "name",
        "created_at",
        "logo_suffix",
        "link",
        "category_alias_name",
        "lang_id",
      ]
    );
    await imageS3Uploader.save(
      `source-logos/${source.logo_suffix}`,
      assetsBucket,
      file
    );
    await trx.commit();
    return source;
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}

async function deleteSource(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  const trx = await db.transaction();
  try {
    const [source] = await trx(tables.news_source)
      .where({ id: val })
      .del()
      .returning("logo_suffix");
    if (source != null)
      await imageS3Uploader.del(
        `category-images/${source.image_suffix}`,
        assetsBucket
      );
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}

async function update(
  body: unknown,
  id: unknown,
  file: Express.Multer.File | undefined
) {
  const val = await Joi.number().validateAsync(id);
  const { error, value } = sourceValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null || file == null) {
    throw new Error();
  }
  const trx = await db.transaction();
  try {
    const [source] = await trx(tables.news_source)
      .update(
        {
          lang_id: value.lang_id,
          logo_suffix: value.logo_suffix,
          name: value.name,
          link: value.link,
          category_alias_name: value.category_alias_name,
        },
        [
          "id",
          "name",
          "created_at",
          "logo_suffix",
          "link",
          "category_alias_name",
          "lang_id",
        ]
      )
      .where({ id: val });
    await imageS3Uploader.save(
      `source-logos/${source.logo_suffix}`,
      assetsBucket,
      file
    );
    await trx.commit();
    return source;
  } catch (error) {
    await trx.rollback();
    throw error;
  }
}

export default { delete: deleteSource, insert, update };
