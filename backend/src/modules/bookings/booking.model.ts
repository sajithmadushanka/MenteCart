import {
    Schema,
    model,
} from "mongoose";

import {
    BookingDocument,
} from "./booking.types";

import {
    BookingStatus,
    PaymentMethod,
    PaymentStatus,
} from "./booking.enums";

const bookingItemSchema =
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

                index: true,
            },

            selectedTimeSlot: {
                type: String,

                required: true,

                index: true,
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


        },
        {
            _id: true,
        }
    );
const bookingSchema =
    new Schema<BookingDocument>(
        {
            userId: {
                type:
                    Schema.Types.ObjectId,

                ref: "User",

                required: true,

                index: true,
            },

            bookingNumber: {
                type: String,

                required: true,

                unique: true,

                index: true,
            },

            items: {
                type: [bookingItemSchema],

                required: true,
            },

            totalItems: {
                type: Number,

                required: true,

                min: 1,
            },

            totalAmount: {
                type: Number,

                required: true,

                min: 0,
            },

            status: {
                type: String,

                enum: Object.values(
                    BookingStatus
                ),

                default:
                    BookingStatus.PENDING,

                index: true,
            },

            bookedAt: {
                type: Date,

                required: true,
            },
            paymentMethod: {
                type: String,

                enum: Object.values(
                    PaymentMethod
                ),

                required: true,

                index: true,
            },

            paymentStatus: {
                type: String,

                enum: Object.values(
                    PaymentStatus
                ),

                required: true,

                index: true,
            },

            transactionId: {
                type: String,
            },

            paidAt: {
                type: Date,
            },
        },
        {
            timestamps: true,

            versionKey: false,
        }
    );

bookingSchema.index({
    "items.serviceId": 1,

    "items.selectedDate": 1,

    "items.selectedTimeSlot": 1,

    status: 1,
});

export const BookingModel =
    model<BookingDocument>(
        "Booking",
        bookingSchema
    );