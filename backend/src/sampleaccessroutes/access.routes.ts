import { Router, Request, Response } from "express";
import { checkJwtAuth } from "../middlewares/auth.middleware";

const AuthRoutes = {
  path: "/access",
  initializeRoutes(): Router {
    const router = Router();

    router.get("/public", (req: Request, res: Response) => {
      res.status(200).json({
        message: "Hello from a public endpoint! You don't need to be authetnicated to see this.",
      });
    });

    router.get("/protected", checkJwtAuth, (req: Request, res: Response) => {
      res.status(200).json({
        message: "Hello from a protected endpoint! You need to be authenticated to see this.",
      });
    });

    return router;
  },
};

export default AuthRoutes;
