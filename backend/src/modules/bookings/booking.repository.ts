import {
    ClientSession,
    QueryFilter,
    Types,
} from "mongoose";

import { BookingModel } from "./booking.model";

import {
    BookingDocument,
} from "./booking.types";

import {
    BookingStatus,
    PaymentStatus,
} from "./booking.enums";

export class BookingRepository {
    async create(
        payload: Partial<BookingDocument>,
        session?: ClientSession
    ) {
        const bookings =
            await BookingModel.create(
                [payload],
                {
                    session,
                }
            );

        return bookings[0];
    }
    async findById(
        bookingId: string
    ) {
        return BookingModel.findById(
            bookingId
        ).exec();
    }
    async findUserBooking(
        bookingId: string,
        userId: string
    ) {
        return BookingModel.findOne({
            _id: bookingId,

            userId,
        }).exec();
    }
    async findUserBookings(
        userId: string
    ) {
        return BookingModel.find({
            userId,
        })
            .sort({
                createdAt: -1,
            })
            .exec();
    }
    async updateStatus(
        bookingId: string,
        status: BookingStatus
    ) {
        return BookingModel.findByIdAndUpdate(
            bookingId,
            {
                status,
            },
            {
                returnDocument: "after"
            }
        ).exec();
    }
    async getReservedCapacity(params: {
        serviceId: string;

        selectedDate: string;

        selectedTimeSlot: string;
    }) {
        const result =
            await BookingModel.aggregate([
                {
                    $match: {
                        status: {
                            $in: [
                                BookingStatus.PENDING,

                                BookingStatus.CONFIRMED,
                            ],
                        },
                    },
                },

                {
                    $unwind: "$items",
                },

                {
                    $match: {
                        "items.serviceId":
                            new Types.ObjectId(
                                params.serviceId
                            ),

                        "items.selectedDate":
                            params.selectedDate,

                        "items.selectedTimeSlot":
                            params.selectedTimeSlot,
                    },
                },

                {
                    $group: {
                        _id: null,

                        totalReserved: {
                            $sum:
                                "$items.quantity",
                        },
                    },
                },
            ]);

        return (
            result[0]?.totalReserved ||
            0
        );
    }
    async countUserBookingsForDate(
        userId: string,
        selectedDate: string
    ) {
        const result =
            await BookingModel.aggregate([
                {
                    $match: {
                        userId: new Types.ObjectId(userId),

                        status: {
                            $in: [
                                BookingStatus.PENDING,

                                BookingStatus.CONFIRMED,
                            ],
                        },
                    },
                },

                {
                    $unwind: "$items",
                },

                {
                    $match: {
                        "items.selectedDate":
                            selectedDate,
                    },
                },

                {
                    $count: "totalBookings",
                },
            ]);

        return (
            result[0]?.totalBookings ||
            0
        );
    }


    async findByBookingNumber(
        bookingNumber: string
    ) {
        return BookingModel.findOne({
            bookingNumber,
        }).exec();
    }
    async updatePaymentSuccess(
        bookingId: string,
        transactionId: string
    ) {
        return BookingModel.findByIdAndUpdate(
            bookingId,
            {
                status:
                    BookingStatus.CONFIRMED,

                paymentStatus:
                    PaymentStatus.PAID,

                transactionId,

                paidAt: new Date(),
            },
            {
                returnDocument: "after"
            }
        ).exec();
    }

    async updatePaymentFailed(
        bookingId: string
    ) {
        return BookingModel.findByIdAndUpdate(
            bookingId,
            {
                status:
                    BookingStatus.FAILED,

                paymentStatus:
                    PaymentStatus.FAILED,
            },
            {
               returnDocument: "after"
            }
        ).exec();
    }
}