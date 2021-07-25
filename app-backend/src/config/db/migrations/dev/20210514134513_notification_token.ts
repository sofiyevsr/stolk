import { Knex } from "knex";

import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.notification_token, (t) => {
    t.increments("id");
    t.string("token").notNullable().unique();
    t.integer("user_id")
      .references("id")
      .inTable(tables.app_user)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.notification_token} CASCADE`);
}
