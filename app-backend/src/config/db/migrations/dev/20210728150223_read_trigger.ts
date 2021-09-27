import { Knex } from "knex";
import path from "path";
import fileToRaw from "../../../../utils/commons/sqlToKnex";
import { functions, triggers, tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  const readF = await fileToRaw(
    path.resolve(__dirname, `../../functions/read.sql`)
  );
  const readT = await fileToRaw(
    path.resolve(__dirname, `../../triggers/read.sql`)
  );
  await knex.schema.raw(readF);
  await knex.schema.raw(readT);
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.raw(
    `DROP TRIGGER IF EXISTS ${triggers.read_trigger} ON ${tables.news_read_history};`
  );
  await knex.schema.raw(`DROP FUNCTION IF EXISTS ${functions.read_news};`);
}
