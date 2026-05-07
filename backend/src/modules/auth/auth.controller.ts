import { Request, Response } from "express";

import { AuthService } from "./auth.service";



import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { successResponse } from "../../shared/responses/apiResponses";

export class AuthController {
    private authService =
        new AuthService();

    signup = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const result =
            await this.authService.signup({
                ...req.body,

                userAgent:
                    req.headers["user-agent"],

                ipAddress: req.ip,
            });

        res.status(HTTP_STATUS.CREATED).json(
            successResponse(
                result,
                "User registered successfully"
            )
        );
    };


    login = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const result =
            await this.authService.login({
                ...req.body,

                userAgent:
                    req.headers["user-agent"],

                ipAddress: req.ip,
            });

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                result,
                "Login successful"
            )
        );
    };


    me = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const user =
            await this.authService.getCurrentUser(
                req.user!.userId
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                user,
                "Current user fetched"
            )
        );
    };


    refreshToken = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const result =
            await this.authService.refreshToken(
                req.body.refreshToken
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                result,
                "Token refreshed successfully"
            )
        );
    };

    logout = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        await this.authService.logout(
            req.body.refreshToken
        );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                null,
                "Logout successful"
            )
        );
    };

    logoutAllDevices = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        await this.authService.logoutAllDevices(
            req.user!.userId
        );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                null,
                "Logged out from all devices"
            )
        );
    };
}