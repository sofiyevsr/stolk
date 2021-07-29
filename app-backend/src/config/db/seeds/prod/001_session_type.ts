import { Knex } from "knex";
import { SessionType, tables } from "../../../../utils/constants";

// eslint-disable-next-line
export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.session_type).del();

  // Inserts seed entries
  await knex(tables.session_type).insert([
    { id: SessionType.IOS, name: "ios" },
    { id: SessionType.ANDROID, name: "android" },
  ]);
}
