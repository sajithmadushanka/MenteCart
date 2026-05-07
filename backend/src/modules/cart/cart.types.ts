import { Types } from "mongoose";

export interface CartItemSnapshot {
    title: string;

    imageUrl?: string;

    duration: number;
}

export interface CartItem {
    _id?: Types.ObjectId;

    serviceId: Types.ObjectId;

    serviceSnapshot: CartItemSnapshot;

    selectedDate: string;

    selectedTimeSlot: string;

    quantity: number;

    unitPrice: number;

    subtotal: number;

    expiresAt: Date;
}

export interface CartDocument {
    _id: Types.ObjectId;

    userId: Types.ObjectId;

    items: CartItem[];

    totalItems: number;

    totalAmount: number;

    createdAt: Date;

    updatedAt: Date;
}