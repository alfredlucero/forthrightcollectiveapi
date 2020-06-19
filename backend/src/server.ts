// When running our server in production mode in say Heroku,
// the dev dependencies won't be installed, so we need to make sure to guard these dotenv checks
// as we'll provide the environment variables through the Heroku Config Vars
if (process.env.NODE_ENV !== "production") {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  require("dotenv").config({
    path: `./.env.${process.env.CONFIG_ENV}`,
  });
}
import App from "./app";
// import { setupDatabase } from "./db";

// Start up the backend server against the environment's PORT
App.listen(process.env.PORT, () => {
  console.log(`Forthright API starting on port ${process.env.PORT}...`);
});

// We separate the set up of the Express server (app) from actually listening/starting up the server
// for testing purposes and for greater separation of concerns
// setupDatabase();
