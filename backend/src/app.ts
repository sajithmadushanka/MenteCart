import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { errorMiddleware, } from "./app/middleware";
import router from "./routes";
import cookieParser from "cookie-parser";

const app = express();

import path from "path";

app.use(express.static(path.join(__dirname, "../public")));


app.use(express.json());
app.use(
    express.urlencoded({
        extended: true,
    })
);
app.use(cors());
app.use(helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            scriptSrc: ["'self'", "https://www.payhere.lk", "https://static.cloudflareinsights.com", "'unsafe-inline'"],
            scriptSrcAttr: ["'unsafe-inline'"],
            connectSrc: ["'self'", "https://sandbox.payhere.lk", "https://www.payhere.lk"],
            frameSrc: ["https://sandbox.payhere.lk", "https://www.payhere.lk"],
            formAction: ["'self'", "https://sandbox.payhere.lk"],
        }
    }
}));
app.use(morgan("dev"));



app.use(cookieParser());

app.use("/api", router);

// last middleware to handle errors
app.use(errorMiddleware);

app.get("/", (_req, res) => {
    res.status(200).json({
        success: true,
        message: "Welcome to MenteCart API",
    });
});



export default app;