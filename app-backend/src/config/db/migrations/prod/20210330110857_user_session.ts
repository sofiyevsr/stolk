import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable(tables.user_session, (t) => {
    t.increments("id");
    t.string("token").notNullable();
    t.integer("user_id")
      .references("id")
      .inTable(tables.app_user)
      .notNullable()
      .onDelete("NO ACTION")
      .onUpdate("CASCADE");
    t.integer("session_type_id")
      .references("id")
      .inTable(tables.session_type)
      .notNullable()
      .onDelete("NO ACTION")
      .onUpdate("CASCADE");
    t.timestamp("created_at").defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.raw(`DROP TABLE ${tables.user_session} CASCADE`);
}
