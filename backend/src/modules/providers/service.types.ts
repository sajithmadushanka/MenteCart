import { Types } from "mongoose";

import { ServiceCategory } from "./service.enums";

export interface ServiceDocument {
    title: string;

    description: string;

    price: number;

    duration: number;

    category: ServiceCategory;

    imageUrl?: string;

    capacityPerSlot: number;

    isActive: boolean;

    createdBy: Types.ObjectId;

    createdAt: Date;

    updatedAt: Date;
}