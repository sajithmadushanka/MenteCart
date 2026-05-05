import express from "express";

const app = express();

app.get("/", (_req, res) => {
  res.status(200).json({
    success: true,
    message: "MenteCart API is running",
  });
});

export default app;