
// Avoid repetitive try/catch blocks in async route handlers and middleware by using this helper function.

import { Request, Response, NextFunction } from "express";

export const asyncHandler =
  (
    fn: (
      req: Request,
      res: Response,
      next: NextFunction
    ) => Promise<unknown>
  ) =>
  (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };