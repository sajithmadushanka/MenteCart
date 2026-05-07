import { z } from "zod";

import { BookingStatus } from "./booking.enums";
export const checkoutBookingSchema =
    z.object({
        body: z.object({
            paymentMethod: z.enum([
                "payhere",
                "cash",
            ]),
        }),
    });
export const bookingIdParamSchema =
    z.object({
        params: z.object({
            id: z
                .string()
                .regex(
                    /^[0-9a-fA-F]{24}$/,
                    "Invalid booking id"
                ),
        }),
    });
export const cancelBookingSchema =
    z.object({
        body: z
            .object({
                reason: z
                    .string()
                    .trim()
                    .max(500)
                    .optional(),
            })
            .optional(),
    });
export const updateBookingStatusSchema =
    z.object({
        body: z.object({
            status: z.nativeEnum(
                BookingStatus
            ),
        }),
    });