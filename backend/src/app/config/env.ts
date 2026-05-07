import dotenv from "dotenv";
dotenv.config();

const requiredEnvVariables = [
    "MONGO_URI",
    "JWT_ACCESS_SECRET",
    "JWT_REFRESH_SECRET",
] as const;

requiredEnvVariables.forEach((key) => {
    if (!process.env[key]) {
        throw new Error(`Missing required env variable: ${key}`);
    }
});


export const env = {
    port: process.env.PORT || 5000,
    mongoUri: process.env.MONGO_URI || "",
    nodeEnv: process.env.NODE_ENV || "development",

    jwt: {
        accessSecret: process.env.JWT_ACCESS_SECRET as string,
        refreshSecret: process.env.JWT_REFRESH_SECRET as string,

        accessExpiresIn:
            process.env.ACCESS_TOKEN_EXPIRES_IN || "15m",

        refreshExpiresIn:
            process.env.REFRESH_TOKEN_EXPIRES_IN || "7d",
    },

    bcrypt: {
        saltRounds: Number(
            process.env.BCRYPT_SALT_ROUNDS || 12
        ),
    },
};
