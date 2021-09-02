import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.notification_type, (t) => {
    t.increments("id").primary();
    t.string("name").notNullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.notification_type} CASCADE`);
}
