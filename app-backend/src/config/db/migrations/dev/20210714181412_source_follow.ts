import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.source_follow, (t) => {
    t.increments("id");
    t.integer("user_id")
      .notNullable()
      .references("id")
      .inTable(tables.base_user)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("source_id")
      .notNullable()
      .references("id")
      .inTable(tables.news_source)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.unique(["user_id", "source_id"]);
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.source_follow} CASCADE`);
}
