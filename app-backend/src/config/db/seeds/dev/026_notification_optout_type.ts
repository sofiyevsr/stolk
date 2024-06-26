import { Knex } from "knex";
import { NotificationOptoutType, tables } from "../../../../utils/constants";

// eslint-disable-next-line
export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.notification_type).del();

  // Inserts seed entries
  await knex(tables.notification_type).insert([
    { id: NotificationOptoutType.SuggestedNews, name: "suggested_news" },
    { id: NotificationOptoutType.Updates, name: "updates" },
  ]);
}
