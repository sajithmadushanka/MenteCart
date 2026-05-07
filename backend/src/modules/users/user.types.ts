import { UserRole } from "../auth/auth.enums";

export interface UserDocument {
  name: string;

  email: string;

  password: string;

  role: UserRole;

  isActive: boolean;

  createdAt: Date;

  updatedAt: Date;
}