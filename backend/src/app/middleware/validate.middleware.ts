import { NextFunction, Request, Response } from "express";

import { ZodSchema, ZodError } from "zod";
import { errorResponse } from "../../shared/responses/apiResponses";
import { HTTP_STATUS } from "../../shared/responses/httpStatus";



export const validate =
    (schema: ZodSchema) =>
        (
            req: Request,
            res: Response,
            next: NextFunction
        ): void => {
            try {
                schema.parse({
                    body: req.body,
                    query: req.query,
                    params: req.params,
                });

                next();
            } catch (error) {
                if (error instanceof ZodError) {
                    const formattedErrors = error.issues.map((err) => ({
                        field: err.path.join("."),

                        message: err.message,
                    }));

                    res.status(HTTP_STATUS.BAD_REQUEST).json(
                        errorResponse(
                            HTTP_STATUS.BAD_REQUEST,
                            "Validation failed",
                            "VALIDATION_ERROR",
                            formattedErrors
                        )
                    );

                    return;
                }

                next(error);
            }
        };