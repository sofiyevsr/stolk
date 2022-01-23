import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.news_category, (t) => {
    t.increments("id");
    t.string("name_en").unique().notNullable();
    t.string("name_ru").unique().notNullable();
    t.string("name_az").unique().notNullable();
    t.string("image_suffix").notNullable();
    // Start new category hidden
    t.timestamp("hidden_at", { useTz: true }).defaultTo(knex.fn.now());
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_category} CASCADE`);
}
