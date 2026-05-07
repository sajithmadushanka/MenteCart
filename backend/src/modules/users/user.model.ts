import { Schema, model } from "mongoose";

import { UserRole } from "../auth/auth.enums";

import { UserDocument } from "./user.types";

const userSchema = new Schema<UserDocument>(
    {
        name: {
            type: String,
            required: true,

            trim: true,

            minlength: 3,

            maxlength: 50,
        },

        email: {
            type: String,
            required: true,

            unique: true,

            lowercase: true,

            trim: true,

            index: true,
        },

        password: {
            type: String,
            required: true,

            select: false,
        },

        role: {
            type: String,

            enum: Object.values(UserRole),

            default: UserRole.USER,
        },

        isActive: {
            type: Boolean,

            default: true,
        },
    },
    {
        timestamps: true,

        versionKey: false,
    }
);

export const UserModel = model<UserDocument>(
    "User",
    userSchema
);