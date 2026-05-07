import { z } from "zod";

export const signupSchema = z.object({
  body: z.object({
    name: z
      .string()
      .trim()
      .min(3, "Name must be at least 3 characters")
      .max(50, "Name cannot exceed 50 characters"),

    email: z
      .email("Invalid email address")
      .toLowerCase(),

    password: z
      .string()
      .min(8, "Password must be at least 8 characters")
      .max(100, "Password is too long")
      .regex(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/,
        "Password must contain uppercase, lowercase, and number"
      ),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z
      .email("Invalid email address")
      .toLowerCase(),

    password: z.string().min(1, "Password is required"),
  }),
});