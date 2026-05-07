
import { BookingRepository } from "../bookings/booking.repository";

import {
    BookingStatus,
    PaymentStatus,
} from "../bookings/booking.enums";

import { AppError } from "../../app/errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";

import {
    generatePayHereHash,
    generatePayHereWebhookHash,
} from "./payment.utils";
import { BookingModel } from "../bookings/booking.model";


export class PaymentService {
    private bookingRepository =
        new BookingRepository();


    async initializePayHerePayment(
        bookingId: string
    ) {

        console.log("bookingId", bookingId);

        const booking =
            await this.bookingRepository.findById(
                bookingId
            );

        console.log("booking", booking);

        const allBookings =
            await BookingModel.find();

        console.log(allBookings);
        if (!booking) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Booking not found",
                "BOOKING_NOT_FOUND"
            );
        }

        const merchantId =
            process.env
                .PAYHERE_MERCHANT_ID!;

        const merchantSecret =
            process.env
                .PAYHERE_MERCHANT_SECRET!;

        const amount =
            booking.totalAmount.toFixed(
                2
            );
        console.log("merchanSecret", merchantSecret);
        const currency =
            "LKR";

        const hash =
            generatePayHereHash({
                merchantId,

                merchantSecret,

                orderId:
                    booking.bookingNumber,

                amount,

                currency
            });


        return {
            sandbox:
                process.env
                    .PAYHERE_SANDBOX ===
                "true",

            merchant_id:
                merchantId,

            return_url:
                process.env
                    .PAYHERE_RETURN_URL,

            cancel_url:
                process.env
                    .PAYHERE_CANCEL_URL,

            notify_url:
                process.env
                    .PAYHERE_NOTIFY_URL,

            order_id:
                booking.bookingNumber,

            items:
                `Booking ${booking.bookingNumber}`,

            amount,

            currency,

            first_name: "Test",

            last_name: "User",

            email:
                "test@example.com",

            phone:
                "0771234567",

            address:
                "Colombo",

            city:
                "Colombo",

            country:
                "Sri Lanka",

            hash,
        };
    }

    async handlePayHereWebhook(
        payload: any
    ) {
        console.log(
            "WEBHOOK RECEIVED",
            payload
        );
        
        const merchantSecret =
            process.env
                .PAYHERE_MERCHANT_SECRET!;

        const generatedHash =
            generatePayHereWebhookHash(
                {
                    merchantId:
                        payload.merchant_id,

                    orderId:
                        payload.order_id,

                    amount:
                        payload.payhere_amount,

                    currency:
                        payload.payhere_currency,

                    statusCode:
                        payload.status_code,

                    merchantSecret,
                }
            );

        if (
            generatedHash !==
            payload.md5sig
        ) {
            throw new AppError(
                HTTP_STATUS.BAD_REQUEST,
                "Invalid payment signature",
                "INVALID_PAYMENT_SIGNATURE"
            );
        }

        const booking =
            await this.bookingRepository.findByBookingNumber(
                payload.order_id
            );

        if (!booking) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Booking not found",
                "BOOKING_NOT_FOUND"
            );
        }

        if (
            booking.paymentStatus ===
            PaymentStatus.PAID
        ) {
            return;
        }

        if (
            payload.status_code ===
            "2"
        ) {
            await this.bookingRepository.updatePaymentSuccess(
                booking._id.toString(),

                payload.payment_id
            );

            return;
        }

        await this.bookingRepository.updatePaymentFailed(
            booking._id.toString()
        );
    }
}