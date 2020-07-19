const config = {
  CONFIG_ENV: process.env.CONFIG_ENV,
  NODE_ENV: process.env.NODE_ENV,
  PORT: process.env.PORT || 8000,
  PGUSER: process.env.PGUSER || "forthrightapiuser",
  PGPASSWORD: process.env.PGPASSWORD || "testing123",
  PGHOST: process.env.PGHOST || "localhost",
  PGPORT: process.env.PGPORT || 5432,
  PGDATABASE: process.env.PGDATABASE || "forthrightapi",
  APP_ORIGIN: process.env.APP_ORIGIN || "http://localhost:3000",
  AUTH0_AUDIENCE: process.env.AUTH0_AUDIENCE || "",
  AUTH0_ISSUER: process.env.AUTH0_ISSUER || "",
};

console.log("Config: ", config);

export default config;
