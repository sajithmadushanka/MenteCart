import {
    Request,
    Response,
} from "express";

import { BookingService } from "./booking.service";



import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { successResponse } from "../../shared/responses/apiResponses";

export class BookingController {
    private bookingService =
        new BookingService();

    checkout = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const booking =
            await this.bookingService.checkout(
                req.user!.userId,

                req.body.paymentMethod
            );

        res.status(
            HTTP_STATUS.CREATED
        ).json(
            successResponse(
                booking,
                "Booking created successfully"
            )
        );
    };

    getBookings = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const bookings =
            await this.bookingService.getUserBookings(
                req.user!.userId
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                bookings,
                "Bookings fetched successfully"
            )
        );
    };

    getBookingById = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
        const booking =
            await this.bookingService.getBookingById(
                req.user!.userId,
                id
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                booking,
                "Booking fetched successfully"
            )
        );
    };

    cancelBooking = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
        const booking =
            await this.bookingService.cancelBooking(
                req.user!.userId,
                id
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                booking,
                "Booking cancelled successfully"
            )
        );
    };
}