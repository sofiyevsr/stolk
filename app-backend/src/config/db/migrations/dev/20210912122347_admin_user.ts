import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.admin_user, (t) => {
    t.increments("id");
    t.string("first_name").notNullable();
    t.string("last_name").notNullable();
    t.string("email").unique().notNullable();
    t.string("password").notNullable();
    t.string("token");
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.admin_user} CASCADE`);
}
