import { sources } from "../../../../utils/dbData";
import { Knex } from "knex";
import { tables } from "../../../../utils/constants";

// eslint-disable-next-line
export async function seed(knex: Knex): Promise<void> {
  // Deletes ALL existing entries
  await knex(tables.news_source).del();

  // const transformedSources = sources.map(({ id, name, link }) => ({ id }));
  // Inserts seed entries
  await knex(tables.news_source).insert(sources);
}
