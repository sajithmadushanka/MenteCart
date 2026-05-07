import {
    ClientSession,
    Types,
} from "mongoose";
import { AuthSessionModel } from "./auth.model";



export class AuthRepository {
    async createSession(
        payload: {
            _id?: Types.ObjectId;

            userId: Types.ObjectId;

            refreshTokenHash: string;

            userAgent?: string;

            ipAddress?: string;

            expiresAt: Date;
        },
        session?: ClientSession
    ) {
        const authSession =
            await AuthSessionModel.create(
                [payload],
                {
                    session,
                }
            );

        return authSession[0];
    }

    async findSessionById(
        sessionId: string
    ) {
        return AuthSessionModel.findById(
            sessionId
        );
    }

    async revokeSession(
        sessionId: string
    ) {
        return AuthSessionModel.findByIdAndUpdate(
            sessionId,
            {
                isRevoked: true,
            },
            {
                returnDocument: "after"
            }
        );
    }

    async revokeAllUserSessions(
        userId: string
    ) {
        return AuthSessionModel.updateMany(
            {
                userId,
            },
            {
                isRevoked: true,
            }
        );
    }

    async updateSessionToken(
        sessionId: string,
        refreshTokenHash: string,
        expiresAt: Date
    ) {
        return AuthSessionModel.findByIdAndUpdate(
            sessionId,
            {
                refreshTokenHash,

                expiresAt,

                isRevoked: false,
            },
            {
                returnDocument: "after"
            }
        );
    }

    async revokeSessionById(
        sessionId: string
    ) {
        return AuthSessionModel.findByIdAndUpdate(
            sessionId,
            {
                isRevoked: true,
            },
            {
                returnDocument: "after"
            }
        );
    }
}