import {
    Schema,
    model,
} from "mongoose";

import {
    CartDocument,
} from "./cart.types";

const cartItemSchema =
    new Schema(
        {
            serviceId: {
                type:
                    Schema.Types.ObjectId,

                ref: "Service",

                required: true,
            },

            serviceSnapshot: {
                title: {
                    type: String,

                    required: true,
                },

                imageUrl: {
                    type: String,
                },

                duration: {
                    type: Number,

                    required: true,
                },
            },

            selectedDate: {
                type: String,

                required: true,
            },

            selectedTimeSlot: {
                type: String,

                required: true,
            },

            quantity: {
                type: Number,

                required: true,

                min: 1,
            },

            unitPrice: {
                type: Number,

                required: true,

                min: 0,
            },

            subtotal: {
                type: Number,

                required: true,

                min: 0,
            },

            expiresAt: {
                type: Date,

                required: true,

                index: true,
            },
        },
        {
            _id: true,
        }
    );
const cartSchema =
    new Schema<CartDocument>(
        {
            userId: {
                type:
                    Schema.Types.ObjectId,

                ref: "User",

                required: true,

                unique: true,

                index: true,
            },

            items: {
                type: [cartItemSchema],

                default: [],
            },

            totalItems: {
                type: Number,

                default: 0,

                min: 0,
            },

            totalAmount: {
                type: Number,

                default: 0,

                min: 0,
            },
        },
        {
            timestamps: true,

            versionKey: false,
        }
    );

export const CartModel =
    model<CartDocument>(
        "Cart",
        cartSchema
    );