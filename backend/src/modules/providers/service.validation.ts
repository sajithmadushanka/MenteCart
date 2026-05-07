import { z } from "zod";

import {
    ServiceCategory,
} from "./service.enums";

export const createServiceSchema =
    z.object({
        body: z.object({
            title: z
                .string()
                .trim()
                .min(
                    3,
                    "Title must be at least 3 characters"
                )
                .max(
                    100,
                    "Title cannot exceed 100 characters"
                ),

            description: z
                .string()
                .trim()
                .min(
                    10,
                    "Description must be at least 10 characters"
                )
                .max(
                    2000,
                    "Description too long"
                ),

            price: z
                .number()
                .min(0),

            duration: z
                .number()
                .min(15),

            category: z.nativeEnum(
                ServiceCategory
            ),

            imageUrl: z
                .string()
                .url()
                .optional(),

            capacityPerSlot: z
                .number()
                .int()
                .min(1),
        }),
    });


export const updateServiceSchema =
    z.object({
        body: z.object({
            title: z
                .string()
                .trim()
                .min(3)
                .max(100)
                .optional(),

            description: z
                .string()
                .trim()
                .min(10)
                .max(2000)
                .optional(),

            price: z
                .number()
                .min(0)
                .optional(),

            duration: z
                .number()
                .min(15)
                .optional(),

            category: z
                .nativeEnum(
                    ServiceCategory
                )
                .optional(),

            imageUrl: z
                .string()
                .url()
                .optional(),

            capacityPerSlot: z
                .number()
                .int()
                .min(1)
                .optional(),

            isActive: z
                .boolean()
                .optional(),
        }),
    });


export const serviceQuerySchema =
    z.object({
        query: z.object({
            page: z
                .string()
                .optional()
                .default("1"),

            limit: z
                .string()
                .optional()
                .default("10"),

            search: z
                .string()
                .trim()
                .optional(),

            category: z
                .nativeEnum(
                    ServiceCategory
                )
                .optional(),
        }),
    });

export const serviceIdParamSchema =
    z.object({
        params: z.object({
            id: z
                .string()
                .regex(
                    /^[0-9a-fA-F]{24}$/,
                    "Invalid service id"
                )
        }),
    });