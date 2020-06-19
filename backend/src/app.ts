import express, { Express } from "express";
// Parses body of requests and allows us to access req.body
import bodyParser from "body-parser";
// Sets Access-Control-Allow-Origin headers
import cors from "cors";
// Allows us to compress responses back
import compression from "compression";
// Adds secure HTTP headers
import helmet from "helmet";
// Prevent DDOS attacks on endpoints by adding rate limits to them
import rateLimit from "express-rate-limit";
// Routes
import AuthRoutes from "./auth/auth.routes";

const App = express();

export const initializeMiddlewares = (app: Express): void => {
  // Support application/json type post data
  app.use(bodyParser.json());
  // Support application/x-www-form-urlencoded post data
  app.use(bodyParser.urlencoded({ extended: false }));

  // TODO: set proper CORS for production NODE_ENV
  // By default, sets Access-Control-Allow-Origin to *
  app.use(cors());

  // By default, compresses all responses
  app.use(compression());

  // Adds secure HTTP headers
  app.use(helmet());

  // Enable if you're behind a reverse proxy (Heroku, Bluemix, AWS ELB, Nginx, etc)
  // see https://expressjs.com/en/guide/behind-proxies.html
  // app.set('trust proxy', 1);

  // TODO: figure out reasonable rate limit for endpoints
  const limiter = rateLimit({
    windowMs: 1000, // 1s
    max: 100, // limit each IP to 100 requests per windowMs
  });

  // Apply rate limit to all requests
  app.use(limiter);
};

const initializeRoutes = (app: Express) => {
  // /auth routes
  app.use(AuthRoutes.path, AuthRoutes.initializeRoutes());

  // TODO: add more routes here
};

// TODO: morgan/winston logging
// https://www.digitalocean.com/community/tutorials/how-to-use-winston-to-log-node-js-applications

initializeMiddlewares(App);
initializeRoutes(App);

export default App;
