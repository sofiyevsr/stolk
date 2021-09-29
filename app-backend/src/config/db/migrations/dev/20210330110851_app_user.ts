import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.app_user, (t) => {
    t.integer("id")
      .primary()
      .references("id")
      .inTable(tables.base_user)
      .onDelete("CASCADE")
      .onUpdate("CASCADE");
    t.string("email").notNullable().unique();
    t.string("password").notNullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.app_user} CASCADE`);
}
