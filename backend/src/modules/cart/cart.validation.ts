import z from "zod";

export const addCartItemSchema =
    z.object({
        body: z.object({
            serviceId: z
                .string()
                .regex(
                    /^[0-9a-fA-F]{24}$/,
                    "Invalid service id"
                ),

            selectedDate: z
                .string()
                .regex(
                    /^\d{4}-\d{2}-\d{2}$/,
                    "Invalid date format"
                ),

            selectedTimeSlot: z
                .string()
                .regex(
                    /^([01]\d|2[0-3]):([0-5]\d)$/,
                    "Invalid time slot format"
                ),

            quantity: z
                .number()
                .int()
                .min(1)
                .max(10),
        }),
    });

export const updateCartItemSchema =
    z.object({
        body: z.object({
            selectedDate: z
                .string()
                .regex(
                    /^\d{4}-\d{2}-\d{2}$/,
                    "Invalid date format"
                )
                .optional(),

            selectedTimeSlot: z
                .string()
                .regex(
                    /^([01]\d|2[0-3]):([0-5]\d)$/,
                    "Invalid time slot format"
                )
                .optional(),

            quantity: z
                .number()
                .int()
                .min(1)
                .max(10)
                .optional(),
        }),
    });

export const cartItemParamSchema =
    z.object({
        params: z.object({
            itemId: z
                .string()
                .regex(
                    /^[0-9a-fA-F]{24}$/,
                    "Invalid cart item id"
                ),
        }),
    });