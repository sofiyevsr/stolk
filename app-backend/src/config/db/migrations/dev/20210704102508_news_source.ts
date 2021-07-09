import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.news_source, (t) => {
    t.increments("id");
    t.string("name").unique().notNullable();
    t.string("link").notNullable();
    t.integer("lang_id")
      .notNullable()
      .references("id")
      .inTable(tables.language)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_source} CASCADE`);
}
