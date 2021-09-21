import { Knex } from "knex";
import path from "path";
import fileToRaw from "../../../../utils/commons/sqlToKnex";
import { materializedViews } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  const source = await fileToRaw(
    path.resolve(__dirname, `../../views/analytics_by_source.sql`)
  );
  const category = await fileToRaw(
    path.resolve(__dirname, `../../views/analytics_by_category.sql`)
  );
  const overall = await fileToRaw(
    path.resolve(__dirname, `../../views/analytics_by_overall.sql`)
  );
  await knex.schema.raw(source);
  await knex.schema.raw(category);
  await knex.schema.raw(overall);
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.raw(
    `DROP MATERIALIZED VIEW IF EXISTS ${materializedViews.analytics_by_source}`
  );
  await knex.schema.raw(
    `DROP MATERIALIZED VIEW IF EXISTS ${materializedViews.analytics_by_category}`
  );
  await knex.schema.raw(
    `DROP MATERIALIZED VIEW IF EXISTS ${materializedViews.analytics_by_overall}`
  );
}
