import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.base_user, (t) => {
    t.increments("id");
    t.string("first_name").notNullable();
    t.string("last_name").notNullable();
    t.string("ip_address").notNullable().index();
    t.timestamp("banned_at", { useTz: true });
    t.timestamp("confirmed_at", { useTz: true });
    t.timestamp("completed_at", { useTz: true });
    t.timestamp("created_at", { useTz: true }).defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.base_user} CASCADE`);
}
