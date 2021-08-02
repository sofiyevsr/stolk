import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.news_read_history, (t) => {
    t.increments("id");
    t.integer("user_id")
      .notNullable()
      .references("id")
      .inTable(tables.app_user)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("news_id")
      .notNullable()
      .references("id")
      .inTable(tables.news_feed)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.unique(["user_id", "news_id"]);
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_read_history} CASCADE`);
}
