import {
    Schema,
    model,
} from "mongoose";

import {
    ServiceDocument,
} from "./service.types";

import {
    ServiceCategory,
} from "./service.enums";

const serviceSchema =
    new Schema<ServiceDocument>(
        {
            title: {
                type: String,

                required: true,

                trim: true,

                minlength: 3,

                maxlength: 100,

                index: true,
            },

            description: {
                type: String,

                required: true,

                trim: true,

                minlength: 10,

                maxlength: 2000,
            },

            price: {
                type: Number,

                required: true,

                min: 0,
            },

            duration: {
                type: Number,

                required: true,

                min: 15,
            },

            category: {
                type: String,

                enum: Object.values(
                    ServiceCategory
                ),

                required: true,

                index: true,
            },

            imageUrl: {
                type: String,

                trim: true,
            },

            capacityPerSlot: {
                type: Number,

                required: true,

                min: 1,
            },

            isActive: {
                type: Boolean,

                default: true,

                index: true,
            },

            createdBy: {
                type:
                    Schema.Types.ObjectId,

                ref: "User",

                required: true,
            },
        },
        {
            timestamps: true,

            versionKey: false,
        }
    );

serviceSchema.index({
    title: "text",

    description: "text",
});
export const ServiceModel =
    model<ServiceDocument>(
        "Service",
        serviceSchema
    );