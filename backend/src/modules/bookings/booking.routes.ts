import { Router } from "express";

import { BookingController } from "./booking.controller";

import {
    checkoutBookingSchema,
    bookingIdParamSchema,
    cancelBookingSchema,
} from "./booking.validation";

import { authMiddleware } from "../../app/middleware/auth.middleware";

import { validate } from "../../app/middleware/validate.middleware";

import { asyncHandler } from "../../shared/helpers/asyncHandler";

const router = Router();

const bookingController =
    new BookingController();

router.use(authMiddleware);

router.post(
    "/checkout",

    validate(
        checkoutBookingSchema
    ),

    asyncHandler(
        bookingController.checkout
    )
);

router.get(
    "/",

    asyncHandler(
        bookingController.getBookings
    )
);

router.get(
    "/:id",

    validate(
        bookingIdParamSchema
    ),

    asyncHandler(
        bookingController.getBookingById
    )
);

router.patch(
    "/:id/cancel",

    validate(
        cancelBookingSchema
    ),

    asyncHandler(
        bookingController.cancelBooking
    )
);

export default router;