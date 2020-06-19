import { Router, Request, Response } from "express";

const AuthRoutes = {
  path: "/auth",
  initializeRoutes(): Router {
    const router = Router();

    router.post("/signup", (req: Request, res: Response) => {
      res.status(200).json("Success");
    });

    router.post("/login", (req: Request, res: Response) => {
      res.status(200).json("Success");
    });

    return router;
  },
};

export default AuthRoutes;
