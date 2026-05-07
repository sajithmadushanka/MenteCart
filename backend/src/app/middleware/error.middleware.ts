import {
    NextFunction,
    Request,
    Response,
} from "express";

import { AppError } from "../errors/AppError";



import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { errorResponse } from "../../shared/responses/apiResponses";

export const errorMiddleware = (
    error: Error | AppError,
    _req: Request,
    res: Response,
    _next: NextFunction
): void => {
    if (error instanceof AppError) {
        res.status(error.statusCode).json(
            errorResponse(
                error.statusCode,
                error.message,
                error.errorCode
            )
        );

        return;
    }

    console.error(error);

    res
        .status(
            HTTP_STATUS.INTERNAL_SERVER_ERROR
        )
        .json(
            errorResponse(
                HTTP_STATUS.INTERNAL_SERVER_ERROR,
                "Internal server error",
                "INTERNAL_SERVER_ERROR"
            )
        );
};