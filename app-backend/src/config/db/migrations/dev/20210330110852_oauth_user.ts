import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.oauth_user, (t) => {
    t.integer("id")
      .primary()
      .references("id")
      .inTable(tables.base_user)
      .onDelete("CASCADE")
      .onUpdate("CASCADE");
    t.string("email").notNullable();
    t.integer("service_type_id")
      .notNullable()
      .references("id")
      .inTable(tables.service_type)
      .onDelete("NO ACTION")
      .onUpdate("CASCADE");
    t.string("oauth_id").notNullable();
    t.unique(["service_type_id", "oauth_id"]);
    t.unique(["service_type_id", "email"]);
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.oauth_user} CASCADE`);
}
