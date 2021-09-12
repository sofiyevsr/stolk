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
      password: "$2b$10$WcmYCvsKkPyp4NN4vuBU1.LCTv6nfwdadwaOs/OG11mUqhYuD9yeW",
    },
  ]);
}
