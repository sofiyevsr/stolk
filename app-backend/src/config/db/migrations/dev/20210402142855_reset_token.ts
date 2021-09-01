import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.reset_token, (t) => {
    t.increments("id");
    t.integer("user_id")
      .notNullable()
      .unique()
      .references("id")
      .inTable(tables.app_user)
      .onDelete("CASCADE")
      .onUpdate("CASCADE");
    t.string("token").notNullable().unique();
    t.timestamp("issued_at", { useTz: true })
      .notNullable()
      .defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.reset_token} CASCADE`);
}
