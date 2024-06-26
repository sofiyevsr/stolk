import { Knex } from "knex";
import { ServiceType, tables } from "../../../../utils/constants";

// eslint-disable-next-line
export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.service_type).del();

  // Inserts seed entries
  await knex(tables.service_type).insert([
    { id: ServiceType.GOOGLE, name: "google" },
    { id: ServiceType.APPLE, name: "apple" },
    { id: ServiceType.FACEBOOK, name: "facebook" },
  ]);
}
