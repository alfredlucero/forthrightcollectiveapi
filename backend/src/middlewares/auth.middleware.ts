import { Handler } from "express";
import jwt from "express-jwt";
import jwks from "jwks-rsa";
import jwtAuthz from "express-jwt-authz";
import config from "../config";

// Checks JWT Authentication with Auth0
export const checkJwtAuth = jwt({
  secret: jwks.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: `${config.AUTH0_ISSUER}.well-known/jwks.json`,
  }),
  audience: config.AUTH0_AUDIENCE,
  issuer: config.AUTH0_ISSUER,
  algorithms: ["RS256"],
});

// Pass in the scopes that a user should have to access a certain endpoint
export const checkScopes = (scopes: string[]): Handler => jwtAuthz(scopes);
