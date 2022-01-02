import db from "@config/db/db";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import sourceValidation from "@admin/utils/validations/source/insert";
import Joi from "joi";

async function insert(body: unknown) {
  const { error, value } = sourceValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

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
  return source;
}

async function deleteSource(id: string | undefined) {
  const val = await Joi.number().validateAsync(id);
  await db(tables.news_source).where({ id: val }).del();
}

async function update(body: unknown, id: unknown) {
  const val = await Joi.number().validateAsync(id);
  const { error, value } = sourceValidation.validate(body);
  if (error) {
    throw new SoftError(error.message);
  }

  if (value == null) {
    throw new Error();
  }

  const [source] = await db(tables.news_source)
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
  return source;
}

export default { delete: deleteSource, insert, update };
