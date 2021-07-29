import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.app_user, (t) => {
    t.increments("id");
    t.string("first_name").notNullable();
    t.string("last_name").notNullable();
    t.string("email").unique().notNullable();
    t.string("password").notNullable();
    t.timestamp("banned_at", { useTz: true });
    t.timestamp("confirmed_at", { useTz: true });
    t.integer("service_type_id")
      .notNullable()
      .references("id")
      .inTable(tables.service_type)
      .onDelete("NO ACTION")
      .onUpdate("CASCADE");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.app_user} CASCADE`);
}
