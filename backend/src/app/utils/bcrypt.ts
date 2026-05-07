import bcrypt from "bcryptjs";

import { env } from "../../app/config/env";

export const hashPassword = async (
  password: string
): Promise<string> => {
  return bcrypt.hash(
    password,
    env.bcrypt.saltRounds
  );
};

export const comparePassword = async (
  password: string,
  hashedPassword: string
): Promise<boolean> => {
  return bcrypt.compare(
    password,
    hashedPassword
  );
};