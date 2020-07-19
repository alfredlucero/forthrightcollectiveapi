import { Pool } from "pg";
import config from "./config";

const isProduction = config.NODE_ENV === "production";

const connectionString = `postgresql://${config.PGUSER}:${config.PGPASSWORD}@${config.PGHOST}:${config.PGPORT}/${config.PGDATABASE}`;

export const pool = new Pool({
  connectionString,
  ssl: isProduction,
});
