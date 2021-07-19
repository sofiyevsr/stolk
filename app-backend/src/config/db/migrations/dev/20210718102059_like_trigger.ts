import { Knex } from "knex";
import path from "path";
import fileToRaw from "../../../../utils/commons/sqlToKnex";
import { tables, functions, triggers } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  const likeF = await fileToRaw(
    path.resolve(__dirname, `../../functions/like.sql`)
  );
  const likeT = await fileToRaw(
    path.resolve(__dirname, `../../triggers/like.sql`)
  );
  await knex.schema.raw(likeF);
  await knex.schema.raw(likeT);
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.raw(
    `DROP TRIGGER IF EXISTS ${triggers.like_trigger} ON ${tables.news_like};`
  );
  await knex.schema.raw(
    `DROP TRIGGER IF EXISTS ${triggers.unlike_trigger} ON ${tables.news_like};`
  );
  await knex.schema.raw(`DROP FUNCTION IF EXISTS ${functions.like_news};`);
  await knex.schema.raw(`DROP FUNCTION IF EXISTS ${functions.unlike_news};`);
}
