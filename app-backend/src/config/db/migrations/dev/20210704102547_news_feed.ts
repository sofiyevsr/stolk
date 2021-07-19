import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable(tables.news_feed, (t) => {
    t.increments("id");
    t.specificType("title", "VARCHAR (1000)").notNullable();
    t.specificType("image_link", "VARCHAR (1000)");
    t.specificType("feed_link", "VARCHAR (1000)").unique().notNullable();
    t.integer("like_count").notNullable().defaultTo(0);
    t.integer("comment_count").notNullable().defaultTo(0);
    t.integer("source_id")
      .notNullable()
      .references("id")
      .inTable(tables.news_source)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("category_alias_id")
      .references("id")
      .inTable(tables.news_category_alias)
      .onUpdate("CASCADE");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
    t.timestamp("pub_date", { useTz: true }).notNullable();
  });
  return knex.schema.raw(`ALTER TABLE
    ${tables.news_feed}
    ADD CONSTRAINT
      like_comment_no_negative
    CHECK
    (
    like_count >= 0
      AND
    comment_count >= 0
    )`);
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_feed} CASCADE`);
}
