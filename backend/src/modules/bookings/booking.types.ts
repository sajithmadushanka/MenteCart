import { Types } from "mongoose";

import { BookingStatus, PaymentMethod, PaymentStatus } from "./booking.enums";

export interface BookingItemSnapshot {
    title: string;

    imageUrl?: string;

    duration: number;
}

export interface BookingItem {
    _id?: Types.ObjectId;

    serviceId: Types.ObjectId;

    serviceSnapshot: BookingItemSnapshot;

    selectedDate: string;

    selectedTimeSlot: string;

    quantity: number;

    unitPrice: number;

    subtotal: number;
}

export interface BookingDocument {
    _id: Types.ObjectId;

    userId: Types.ObjectId;

    bookingNumber: string;

    items: BookingItem[];

    totalItems: number;

    totalAmount: number;

    status: BookingStatus;

    bookedAt: Date;

    createdAt: Date;

    updatedAt: Date;


    paymentMethod: PaymentMethod;

    paymentStatus: PaymentStatus;

    transactionId?: string;

    paidAt?: Date;
}