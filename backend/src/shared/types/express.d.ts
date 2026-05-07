import { UserRole } from "../../modules/auth/auth.enums";

declare global {
  namespace Express {
    interface Request {
      user?: {
        userId: string;

        email: string;

        role: UserRole;
      };
    }
  }
}

export {};