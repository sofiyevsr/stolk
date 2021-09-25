import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.notification_optout, (t) => {
    t.increments("id");
    t.integer("user_id")
      .notNullable()
      .references("id")
      .inTable(tables.base_user)
      .onUpdate("CASCADE")
      .onDelete("CASCADE");
    t.integer("notification_type_id")
      .notNullable()
      .references("id")
      .inTable(tables.notification_type)
      .onDelete("NO ACTION")
      .onUpdate("CASCADE");
    t.unique(["notification_type_id", "user_id"]);
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.notification_optout} CASCADE`);
}
