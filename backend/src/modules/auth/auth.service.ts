import mongoose, { Types } from "mongoose";

import { UserRepository } from "../users/user.repository";

import { AuthRepository } from "./auth.repository";

import {
    AUTH_ERROR_CODES,
    AUTH_ERRORS,
} from "./auth.constants";

import {
    AuthResponse,
    AuthUser,
} from "./auth.types";

import { UserRole } from "./auth.enums";

import { comparePassword, hashPassword } from "../../app/utils/bcrypt";

import { hashToken } from "../../app/utils/crypto";

import {
    generateAccessToken,
    generateRefreshToken,
    verifyRefreshToken,
} from "../../app/utils/jwt";
import { AppError } from "../../app/errors/AppError";
import { HTTP_STATUS } from "../../shared/responses/httpStatus";

export class AuthService {
    private userRepository =
        new UserRepository();

    private authRepository =
        new AuthRepository();

    async signup(payload: {
        name: string;

        email: string;

        password: string;

        userAgent?: string;

        ipAddress?: string;
    }): Promise<AuthResponse> {
        const existingUser =
            await this.userRepository.findByEmail(
                payload.email
            );

        if (existingUser) {
            throw new AppError(
                HTTP_STATUS.CONFLICT,
                AUTH_ERRORS.EMAIL_ALREADY_EXISTS,
                AUTH_ERROR_CODES.EMAIL_ALREADY_EXISTS
            );
        }

        const hashedPassword =
            await hashPassword(payload.password);

        const dbSession =
            await mongoose.startSession();

        dbSession.startTransaction();

        try {
            const createdUser =
                await this.userRepository.create(
                    {
                        name: payload.name,

                        email: payload.email,

                        password: hashedPassword,

                        role: UserRole.USER,
                    },
                    dbSession
                );

            const sessionId =
                new Types.ObjectId();

            const refreshToken =
                generateRefreshToken({
                    sessionId:
                        sessionId.toString(),

                    userId:
                        createdUser._id.toString(),
                });

            const refreshTokenHash =
                hashToken(refreshToken);

            await this.authRepository.createSession(
                {
                    _id: sessionId,

                    userId:
                        createdUser._id,

                    refreshTokenHash,

                    userAgent: payload.userAgent,

                    ipAddress: payload.ipAddress,

                    expiresAt: new Date(
                        Date.now() +
                        7 *
                        24 *
                        60 *
                        60 *
                        1000
                    ),
                },
                dbSession
            );

            const accessToken =
                generateAccessToken({
                    userId:
                        createdUser._id.toString(),

                    email: createdUser.email,

                    role: createdUser.role,
                });

            await dbSession.commitTransaction();

            const user: AuthUser = {
                id: createdUser._id.toString(),

                name: createdUser.name,

                email: createdUser.email,

                role: createdUser.role,
            };

            return {
                user,

                tokens: {
                    accessToken,

                    refreshToken,
                },
            };
        } catch (error) {
            await dbSession.abortTransaction();

            throw error;
        } finally {
            dbSession.endSession();
        }
    }



    // sigin ----
    async login(payload: {
        email: string;

        password: string;

        userAgent?: string;

        ipAddress?: string;
    }): Promise<AuthResponse> {
        const user =
            await this.userRepository.findByEmail(
                payload.email
            );

        if (!user) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_CREDENTIALS,
                AUTH_ERROR_CODES.INVALID_CREDENTIALS
            );
        }

        const isPasswordValid =
            await comparePassword(
                payload.password,
                user.password
            );

        if (!isPasswordValid) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_CREDENTIALS,
                AUTH_ERROR_CODES.INVALID_CREDENTIALS
            );
        }

        if (!user.isActive) {
            throw new AppError(
                HTTP_STATUS.FORBIDDEN,
                "Account is disabled",
                "ACCOUNT_DISABLED"
            );
        }

        const sessionId =
            new Types.ObjectId();

        const refreshToken =
            generateRefreshToken({
                sessionId:
                    sessionId.toString(),

                userId:
                    user._id.toString(),
            });

        const refreshTokenHash =
            hashToken(refreshToken);

        await this.authRepository.createSession({
            _id: sessionId,

            userId: user._id,

            refreshTokenHash,

            userAgent: payload.userAgent,

            ipAddress: payload.ipAddress,

            expiresAt: new Date(
                Date.now() +
                7 *
                24 *
                60 *
                60 *
                1000
            ),
        });

        const accessToken =
            generateAccessToken({
                userId:
                    user._id.toString(),

                email: user.email,

                role: user.role,
            });

        const authUser: AuthUser = {
            id: user._id.toString(),

            name: user.name,

            email: user.email,

            role: user.role,
        };

        return {
            user: authUser,

            tokens: {
                accessToken,

                refreshToken,
            },
        };
    }


    async getCurrentUser(
        userId: string
    ): Promise<AuthUser> {
        const user =
            await this.userRepository.findActiveById(
                userId
            );

        if (!user) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "User not found",
                "USER_NOT_FOUND"
            );
        }

        return {
            id: user._id.toString(),

            name: user.name,

            email: user.email,

            role: user.role,
        };
    }

    async refreshToken(
        refreshToken: string
    ): Promise<AuthResponse> {
        let decoded;

        try {
            decoded =
                verifyRefreshToken(
                    refreshToken
                );
        } catch {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_TOKEN,
                AUTH_ERROR_CODES.INVALID_TOKEN
            );
        }

        const session =
            await this.authRepository.findSessionById(
                decoded.sessionId
            );

        if (!session) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_TOKEN,
                AUTH_ERROR_CODES.INVALID_TOKEN
            );
        }

        if (session.isRevoked) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                "Session revoked",
                "SESSION_REVOKED"
            );
        }

        if (
            session.expiresAt <
            new Date()
        ) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                "Session expired",
                "SESSION_EXPIRED"
            );
        }

        const hashedIncomingToken =
            hashToken(refreshToken);

        const isTokenValid =
            hashedIncomingToken ===
            session.refreshTokenHash;

        if (!isTokenValid) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_TOKEN,
                AUTH_ERROR_CODES.INVALID_TOKEN
            );
        }

        const user =
            await this.userRepository.findById(
                decoded.userId
            );

        if (!user || !user.isActive) {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.UNAUTHORIZED,
                AUTH_ERROR_CODES.UNAUTHORIZED
            );
        }

        const newRefreshToken =
            generateRefreshToken({
                sessionId:
                    session._id.toString(),

                userId:
                    user._id.toString(),
            });

        const newRefreshTokenHash =
            hashToken(newRefreshToken);

        const newExpiresAt = new Date(
            Date.now() +
            7 *
            24 *
            60 *
            60 *
            1000
        );

        await this.authRepository.updateSessionToken(
            session._id.toString(),
            newRefreshTokenHash,
            newExpiresAt
        );

        const accessToken =
            generateAccessToken({
                userId:
                    user._id.toString(),

                email: user.email,

                role: user.role,
            });

        return {
            user: {
                id: user._id.toString(),

                name: user.name,

                email: user.email,

                role: user.role,
            },

            tokens: {
                accessToken,

                refreshToken:
                    newRefreshToken,
            },
        };
    }

    async logout(
        refreshToken: string
    ): Promise<void> {
        let decoded;

        try {
            decoded =
                verifyRefreshToken(
                    refreshToken
                );
        } catch {
            throw new AppError(
                HTTP_STATUS.UNAUTHORIZED,
                AUTH_ERRORS.INVALID_TOKEN,
                AUTH_ERROR_CODES.INVALID_TOKEN
            );
        }

        const session =
            await this.authRepository.findSessionById(
                decoded.sessionId
            );

        if (!session) {
            return;
        }

        await this.authRepository.revokeSessionById(
            session._id.toString()
        );
    }
    async logoutAllDevices(
        userId: string
    ): Promise<void> {
        await this.authRepository.revokeAllUserSessions(
            userId
        );
    }
}