import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.comment_report, (t) => {
    t.unique(["comment_id", "user_id"]);
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
    t.integer("comment_id")
      .notNullable()
      .references("id")
      .inTable(tables.news_comment)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.comment_report} CASCADE`);
}
