import mongoose, {
    Types,
} from "mongoose";

import { BookingRepository } from "./booking.repository";

import { CartRepository } from "../cart/cart.repository";


import {
    BookingDocument,
} from "./booking.types";

import {
    BookingStatus,
    PaymentMethod,
    PaymentStatus,
} from "./booking.enums";

import { AppError } from "../../app/errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { ServiceRepository } from "../providers/service.repository";
import { BOOKING_LIMITS } from "./booking.const";

export class BookingService {
    private bookingRepository =
        new BookingRepository();

    private cartRepository =
        new CartRepository();

    private serviceRepository =
        new ServiceRepository();
    private mapBooking(
        booking: BookingDocument
    ) {
        return {
            id: booking._id.toString(),

            bookingNumber:
                booking.bookingNumber,

            items: booking.items.map(
                (item) => ({
                    id:
                        item._id?.toString(),

                    serviceId:
                        item.serviceId.toString(),

                    serviceSnapshot:
                        item.serviceSnapshot,

                    selectedDate:
                        item.selectedDate,

                    selectedTimeSlot:
                        item.selectedTimeSlot,

                    quantity:
                        item.quantity,

                    unitPrice:
                        item.unitPrice,

                    subtotal:
                        item.subtotal,
                })
            ),

            totalItems:
                booking.totalItems,

            totalAmount:
                booking.totalAmount,

            status:
                booking.status,

            paymentMethod:
                booking.paymentMethod,

            paymentStatus:
                booking.paymentStatus,

            transactionId:
                booking.transactionId,

            paidAt:
                booking.paidAt,

            bookedAt:
                booking.bookedAt,
        };
    }

    async checkout(
        userId: string,
        paymentMethod:
            | "card"
            | "cash"
    ) {
        const cart =
            await this.cartRepository.findByUserId(
                userId
            );

        if (
            !cart ||
            cart.items.length === 0
        ) {
            throw new AppError(
                HTTP_STATUS.BAD_REQUEST,
                "Cart is empty",
                "EMPTY_CART"
            );
        }

        const session =
            await mongoose.startSession();

        session.startTransaction();
        const bookingDateCounter =
            new Map<string, number>();
        try {
            for (const item of cart.items) {
                const service =
                    await this.serviceRepository.findActiveById(
                        item.serviceId.toString()
                    );

                if (!service) {
                    throw new AppError(
                        HTTP_STATUS.NOT_FOUND,
                        "Service not found",
                        "SERVICE_NOT_FOUND"
                    );
                }
                // validate booking for a day count ------------
                const userBookingCount =
                    await this.bookingRepository.countUserBookingsForDate(
                        userId,
                        item.selectedDate
                    );
                console.log(userBookingCount);
                console.log(BOOKING_LIMITS.MAX_BOOKINGS_PER_DAY);
                console.log(item.quantity)
                if (
                    userBookingCount + 1 >
                    BOOKING_LIMITS.MAX_BOOKINGS_PER_DAY
                ) {
                    throw new AppError(
                        HTTP_STATUS.CONFLICT,
                        `Daily booking limit exceeded for ${item.selectedDate}`,
                        "DAILY_BOOKING_LIMIT_EXCEEDED"
                    );
                }

                //  -------
                const reservedCapacity =
                    await this.bookingRepository.getReservedCapacity(
                        {
                            serviceId:
                                item.serviceId.toString(),

                            selectedDate:
                                item.selectedDate,

                            selectedTimeSlot:
                                item.selectedTimeSlot,
                        }
                    );

                const remainingCapacity =
                    service.capacityPerSlot -
                    reservedCapacity;

                if (
                    item.quantity >
                    remainingCapacity
                ) {
                    throw new AppError(
                        HTTP_STATUS.CONFLICT,
                        `Slot capacity exceeded for ${service.title}`,
                        "SLOT_CAPACITY_EXCEEDED"
                    );
                }
            }

            const isCashPayment =
                paymentMethod ===
                PaymentMethod.CASH;

            const bookingStatus =
                isCashPayment
                    ? BookingStatus.CONFIRMED
                    : BookingStatus.PENDING;

            const paymentStatus =
                isCashPayment
                    ? PaymentStatus.UNPAID
                    : PaymentStatus.PENDING;

            const booking =
                await this.bookingRepository.create(
                    {
                        userId:
                            new Types.ObjectId(
                                userId
                            ),

                        bookingNumber:
                            this.generateBookingNumber(),

                        items: cart.items.map(
                            (item) => ({
                                serviceId:
                                    item.serviceId,

                                serviceSnapshot:
                                    item.serviceSnapshot,

                                selectedDate:
                                    item.selectedDate,

                                selectedTimeSlot:
                                    item.selectedTimeSlot,

                                quantity:
                                    item.quantity,

                                unitPrice:
                                    item.unitPrice,

                                subtotal:
                                    item.subtotal,
                            })
                        ),

                        totalItems:
                            cart.totalItems,

                        totalAmount:
                            cart.totalAmount,

                        status: bookingStatus,

                        paymentMethod:
                            paymentMethod as PaymentMethod,

                        paymentStatus,

                        bookedAt:
                            new Date(),
                    },
                    session
                );

            cart.items = [];

            cart.totalItems = 0;

            cart.totalAmount = 0;

            await this.cartRepository.saveCart(
                cart
            );

            await session.commitTransaction();

            return this.mapBooking(
                booking
            );
        } catch (error) {
            await session.abortTransaction();

            throw error;
        } finally {
            session.endSession();
        }
    }
    private generateBookingNumber() {
        const timestamp =
            Date.now();

        const random =
            Math.floor(
                1000 +
                Math.random() * 9000
            );

        return `BK-${timestamp}-${random}`;
    }
    async getUserBookings(
        userId: string
    ) {
        const bookings =
            await this.bookingRepository.findUserBookings(
                userId
            );

        return bookings.map(
            (booking) =>
                this.mapBooking(
                    booking
                )
        );
    }
    async getBookingById(
        userId: string,
        bookingId: string
    ) {
        const booking =
            await this.bookingRepository.findUserBooking(
                bookingId,
                userId
            );

        if (!booking) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Booking not found",
                "BOOKING_NOT_FOUND"
            );
        }

        return this.mapBooking(
            booking
        );
    }
    async cancelBooking(
        userId: string,
        bookingId: string
    ) {
        const booking =
            await this.bookingRepository.findUserBooking(
                bookingId,
                userId
            );

        if (!booking) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Booking not found",
                "BOOKING_NOT_FOUND"
            );
        }

        if (
            booking.status ===
            BookingStatus.CANCELLED
        ) {
            throw new AppError(
                HTTP_STATUS.BAD_REQUEST,
                "Booking already cancelled",
                "BOOKING_ALREADY_CANCELLED"
            );
        }

        if (
            booking.status ===
            BookingStatus.COMPLETED ||
            booking.status ===
            BookingStatus.FAILED
        ) {
            throw new AppError(
                HTTP_STATUS.BAD_REQUEST,
                "Booking cannot be cancelled",
                "BOOKING_CANNOT_BE_CANCELLED"
            );
        }

        const earliestItem =
            booking.items.reduce(
                (earliest, item) => {
                    const current =
                        new Date(
                            `${item.selectedDate}T${item.selectedTimeSlot}:00`
                        );

                    return current <
                        earliest
                        ? current
                        : earliest;
                },
                new Date(
                    `${booking.items[0].selectedDate}T${booking.items[0].selectedTimeSlot}:00`
                )
            );

        const cutoff =
            new Date(
                earliestItem.getTime() -
                24 *
                60 *
                60 *
                1000
            );

        if (
            new Date() > cutoff
        ) {
            throw new AppError(
                HTTP_STATUS.BAD_REQUEST,
                "Cancellation cutoff exceeded",
                "CANCELLATION_CUTOFF_EXCEEDED"
            );
        }

        const updatedBooking =
            await this.bookingRepository.updateStatus(
                bookingId,
                BookingStatus.CANCELLED
            );

        return this.mapBooking(
            updatedBooking!
        );
    }
}