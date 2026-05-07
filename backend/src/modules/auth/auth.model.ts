import { Schema, Types, model } from "mongoose";

interface AuthSessionDocument {
    userId: Types.ObjectId;

    refreshTokenHash: string;

    userAgent?: string;

    ipAddress?: string;

    expiresAt: Date;

    isRevoked: boolean;

    createdAt: Date;

    updatedAt: Date;
}

const authSessionSchema =
    new Schema<AuthSessionDocument>(
        {
            userId: {
                type: Schema.Types.ObjectId,

                ref: "User",

                required: true,

                index: true,
            },

            refreshTokenHash: {
                type: String,

                required: true,
            },

            userAgent: {
                type: String,
            },

            ipAddress: {
                type: String,
            },

            expiresAt: {
                type: Date,

                required: true,

               
            },

            isRevoked: {
                type: Boolean,

                default: false,
            },
        },
        {
            timestamps: true,

            versionKey: false,
        }
    );

export const AuthSessionModel =
    model<AuthSessionDocument>(
        "AuthSession",
        authSessionSchema
    );

authSessionSchema.index(
  { expiresAt: 1 },
  { expireAfterSeconds: 0 }
);