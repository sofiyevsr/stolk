import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.confirmation_token, (t) => {
    t.increments("id");
    t.string("token").notNullable().unique();
    t.integer("user_id")
      .references("id")
      .inTable(tables.base_user)
      .unique()
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.timestamp("issued_at", { useTz: true })
      .notNullable()
      .defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.confirmation_token} CASCADE`);
}
