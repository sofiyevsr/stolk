import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable(tables.news_read_history, (t) => {
    t.increments("id");
    t.integer("user_id")
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
    t.string("ip_address");
    // .index();
    t.unique(["user_id", "news_id"]);
    t.unique(["ip_address", "news_id"]);
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
  return knex.schema.raw(`
  ALTER TABLE
    ${tables.news_read_history}
  ADD CONSTRAINT
    user_id_or_ip_not_null
  CHECK
    ((user_id IS NOT NULL)::int + (ip_address IS NOT NULL)::int = 1)
`);
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.news_read_history} CASCADE`);
}
