import { Knex } from "knex";
import { tables } from "../../../../utils/constants";
import { langs } from "../../../../utils/dbData";

// eslint-disable-next-line
export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.language).del();

  // Inserts seed entries
  await knex(tables.language).insert(langs);
}
