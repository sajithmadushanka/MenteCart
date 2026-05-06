import app from "./app";
import { env } from "./app/config/env";
import { connectDB } from "./app/config/db";
import { logger } from "./app/logger/logger";

const startServer = async () => {
  await connectDB();

  app.listen(env.port, () => {
    logger.info(`Server running on port ${env.port}`);
  });
};

startServer();