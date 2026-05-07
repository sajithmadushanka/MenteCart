import {
    NextFunction,
    Request,
    Response,
} from "express";

import { verifyAccessToken } from "../utils/jwt";

import { AppError } from "../errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";

import {
    AUTH_ERROR_CODES,
    AUTH_ERRORS,
} from "../../modules/auth/auth.constants";

export const authMiddleware = (
    req: Request,
    _res: Response,
    next: NextFunction
): void => {
    const authorization =
        req.headers.authorization;

    if (
        !authorization ||
        !authorization.startsWith(
            "Bearer "
        )
    ) {
        return next(
            new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.UNAUTHORIZED,
                AUTH_ERROR_CODES.UNAUTHORIZED
            )
        );
    }

    const token =
        authorization.split(" ")[1];

    try {
        const decoded =
            verifyAccessToken(token);

        req.user = {
            userId: decoded.userId,

            email: decoded.email,

            role: decoded.role,
        };

        next();
    } catch (error) {
        return next(
            new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_TOKEN,
                AUTH_ERROR_CODES.INVALID_TOKEN
            )
        );
    }
};