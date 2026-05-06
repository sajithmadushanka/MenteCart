import mongoose from "mongoose";
import { env } from "./env";
import { logger } from "../logger/logger";

export const connectDB = async () => {
  try {
    await mongoose.connect(env.mongoUri);

    logger.info("MongoDB connected");
  } catch (error) {
    logger.error("MongoDB connection failed");
    process.exit(1);
  }
};