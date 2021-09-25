import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.news_report, (t) => {
    t.unique(["news_id", "user_id"]);
    t.integer("report_id")
      .primary()
      .references("id")
      .inTable(tables.report)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("user_id")
      .notNullable()
      .references("id")
      .inTable(tables.base_user)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("news_id")
      .notNullable()
      .references("id")
      .inTable(tables.news_feed)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_report} CASCADE`);
}
