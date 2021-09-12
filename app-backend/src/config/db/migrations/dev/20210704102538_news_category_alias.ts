import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.news_category_alias, (t) => {
    t.increments("id");
    t.string("alias").unique().notNullable();
    t.integer("category_id")
      .references("id")
      .inTable(tables.news_category)
      .onUpdate("CASCADE")
      .onDelete("SET NULL");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_category_alias} CASCADE`);
}
