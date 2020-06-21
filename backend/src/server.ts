const isProduction = process.env.NODE_ENV === "production";
// When running our server in production mode in say Heroku,
// the dev dependencies won't be installed, so we need to make sure to guard these dotenv checks
// as we'll provide the environment variables through the Heroku Config Vars
if (!isProduction) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  require("dotenv").config({
    path: `./.env.${process.env.CONFIG_ENV}`,
  });
}

import App from "./app";

// Start up the backend server against the environment's PORT
App.listen(process.env.PORT, () => {
  console.log(`Forthright API starting on port ${process.env.PORT}...`);
});
