import http from "http";

import app from "./app";

import { env } from "./app/config/env";
import { connectDB } from "./app/config/db";



const startServer = async () => {
    try {
        await connectDB();

        const server = http.createServer(app);

        server.listen(env.port, () => {
            console.log(
                `Server running on port ${env.port}`
            );
        });

        process.on(
            "unhandledRejection",
            (reason) => {
                console.error(
                    "Unhandled Rejection:",
                    reason
                );

                server.close(() => {
                    process.exit(1);
                });
            }
        );

        process.on(
            "uncaughtException",
            (error) => {
                console.error(
                    "Uncaught Exception:",
                    error
                );

                server.close(() => {
                    process.exit(1);
                });
            }
        );
    } catch (error) {
        console.error(
            "Failed to start server:",
            error
        );

        process.exit(1);
    }
};

startServer();