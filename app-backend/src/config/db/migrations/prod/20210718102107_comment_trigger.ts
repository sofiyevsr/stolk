import { Knex } from "knex";
import path from "path";
import fileToRaw from "../../../../utils/commons/sqlToKnex";
import { functions, triggers, tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  const commentF = await fileToRaw(
    path.resolve(__dirname, `../../functions/comment.sql`)
  );
  const commentT = await fileToRaw(
    path.resolve(__dirname, `../../triggers/comment.sql`)
  );
  await knex.schema.raw(commentF);
  await knex.schema.raw(commentT);
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.raw(
    `DROP TRIGGER IF EXISTS ${triggers.comment_trigger} ON ${tables.news_comment};`
  );
  await knex.schema.raw(
    `DROP TRIGGER IF EXISTS ${triggers.uncomment_trigger} ON ${tables.news_comment};`
  );
  await knex.schema.raw(`DROP FUNCTION IF EXISTS ${functions.comment_news};`);
  await knex.schema.raw(`DROP FUNCTION IF EXISTS ${functions.uncomment_news};`);
}
