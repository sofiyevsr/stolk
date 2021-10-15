import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.admin_user).del();

  // Inserts seed entries
  await knex(tables.admin_user).insert([
    {
      email: "sofiyevsr999@gmail.com",
      first_name: "Rasul",
      last_name: "Sofiyev",
      password: "$2b$10$uVPBZwFedb9V/9wTXCX6hOfUS0ofnMdV7U1c.vXOaxLnUnRDS8wu2",
    },
  ]);
}
