require("dotenv").config();

const config = {
  development: {
    client: "pg",
    connection: {
      host: process.env.SQL_HOST,
      database: process.env.SQL_DATABASE,
      user: process.env.SQL_USER,
      password: process.env.SQL_PASSWORD,
    },
    migrations: {
      tableName: "knex_migrations",
      directory: "./src/config/db/migrations/dev",
    },
    seeds: {
      directory: "./src/config/db/seeds/dev",
    },
  },
  production: {
    client: "pg",
    connection: {
      host: process.env.SQL_HOST,
      database: process.env.SQL_DATABASE,
      user: process.env.SQL_USER,
      password: process.env.SQL_PASSWORD,
    },
    migrations: {
      tableName: "knex_migrations",
      directory: "./src/config/db/migrations/prod",
    },
    seeds: {
      directory: "./src/config/db/seeds/prod",
    },
  },
};

export default config;
