import {
    NextFunction,
    Request,
    Response,
} from "express";

import { UserRole } from "../../modules/auth/auth.enums";

import { AppError } from "../errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";

export const authorize =
    (...roles: UserRole[]) =>
        (
            req: Request,
            _res: Response,
            next: NextFunction
        ): void => {
            if (!req.user) {
                return next(
                    new AppError(
                        HTTP_STATUS.UNAUTHORIZED,
                        "Unauthorized",
                        "AUTH_UNAUTHORIZED"
                    )
                );
            }

            if (
                !roles.includes(req.user.role)
            ) {
                return next(
                    new AppError(
                        HTTP_STATUS.FORBIDDEN,
                        "Forbidden",
                        "AUTH_FORBIDDEN"
                    )
                );
            }

            next();
        };