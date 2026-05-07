import { Types } from "mongoose";

import { CartRepository } from "./cart.repository";



import {
    CartDocument,
    CartItem,
} from "./cart.types";

import { AppError } from "../../app/errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { ServiceRepository } from "../providers/service.repository";
export class CartService {
    private cartRepository =
        new CartRepository();

    private serviceRepository =
        new ServiceRepository();
    private mapCart(
        cart: CartDocument
    ) {
        return {
            id: cart._id.toString(),

            items: cart.items.map(
                (item) => ({
                    id:
                        item._id?.toString(),

                    serviceId:
                        item.serviceId.toString(),

                    serviceSnapshot:
                        item.serviceSnapshot,

                    selectedDate:
                        item.selectedDate,

                    selectedTimeSlot:
                        item.selectedTimeSlot,

                    quantity:
                        item.quantity,

                    unitPrice:
                        item.unitPrice,

                    subtotal:
                        item.subtotal,

                    expiresAt:
                        item.expiresAt,
                })
            ),

            totalItems:
                cart.totalItems,

            totalAmount:
                cart.totalAmount,
        };
    }


    private async getOrCreateCart(
        userId: string
    ) {
        let cart =
            await this.cartRepository.findByUserId(
                userId
            );

        if (!cart) {
            cart =
                await this.cartRepository.createCart(
                    userId
                );
        }

        return cart;
    }


    // ---
    async addItem(
        userId: string,
        payload: {
            serviceId: string;

            selectedDate: string;

            selectedTimeSlot: string;

            quantity: number;
        }
    ) {

        const service =
            await this.serviceRepository.findActiveById(
                payload.serviceId
            );


        if (!service) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Service not found",
                "SERVICE_NOT_FOUND"
            );
        }

        const cart =
            await this.getOrCreateCart(
                userId
            );

        const existingItem =
            cart.items.find(
                (item) =>
                    item.serviceId.toString() ===
                    payload.serviceId &&
                    item.selectedDate ===
                    payload.selectedDate &&
                    item.selectedTimeSlot ===
                    payload.selectedTimeSlot
            );

        if (existingItem) {
            existingItem.quantity +=
                payload.quantity;

            existingItem.subtotal =
                existingItem.quantity *
                existingItem.unitPrice;

            existingItem.expiresAt =
                this.generateExpiration();
        } else {
            const unitPrice =
                service.price;

            const subtotal =
                unitPrice *
                payload.quantity;

            cart.items.push({
                _id: new Types.ObjectId(),

                serviceId: service._id,

                serviceSnapshot: {
                    title: service.title,

                    imageUrl:
                        service.imageUrl,

                    duration:
                        service.duration,
                },

                selectedDate:
                    payload.selectedDate,

                selectedTimeSlot:
                    payload.selectedTimeSlot,

                quantity:
                    payload.quantity,

                unitPrice,

                subtotal,

                expiresAt:
                    this.generateExpiration(),
            });
        }

        this.recalculateCart(cart);

        await this.cartRepository.saveCart(
            cart
        );

        return this.mapCart(cart);
    }

    //  --
    async getCart(
        userId: string
    ) {
        const cart =
            await this.getOrCreateCart(
                userId
            );

        return this.mapCart(cart);
    }

    async updateCartItem(
        userId: string,
        itemId: string,
        payload: {
            quantity?: number;

            selectedDate?: string;

            selectedTimeSlot?: string;
        }
    ) {
        const cart =
            await this.getOrCreateCart(
                userId
            );

        const item =
            this.cartRepository.findCartItem(
                cart,
                itemId
            );



        if (!item) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Cart item not found",
                "CART_ITEM_NOT_FOUND"
            );
        }

        if (payload.quantity) {
            item.quantity =
                payload.quantity;

            item.subtotal =
                item.quantity *
                item.unitPrice;
        }

        if (payload.selectedDate) {
            item.selectedDate =
                payload.selectedDate;
        }

        if (payload.selectedTimeSlot) {
            item.selectedTimeSlot =
                payload.selectedTimeSlot;
        }

        item.expiresAt =
            this.generateExpiration();

        this.recalculateCart(cart);

        await this.cartRepository.saveCart(
            cart
        );

        return this.mapCart(cart);
    }


    async removeCartItem(
        userId: string,
        itemId: string
    ) {
        const cart =
            await this.getOrCreateCart(
                userId
            );

        const item =
            this.cartRepository.findCartItem(
                cart,
                itemId
            );

        if (!item) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Cart item not found",
                "CART_ITEM_NOT_FOUND"
            );
        }

        this.cartRepository.removeCartItem(
            cart,
            itemId
        );

        this.recalculateCart(cart);

        await this.cartRepository.saveCart(
            cart
        );

        return this.mapCart(cart);
    }
    async clearCart(
        userId: string
    ) {
        const cart =
            await this.getOrCreateCart(
                userId
            );

        this.cartRepository.clearCart(
            cart
        );

        await this.cartRepository.saveCart(
            cart
        );
    }
    private recalculateCart(
        cart: CartDocument
    ) {
        cart.totalItems =
            cart.items.reduce(
                (sum, item) =>
                    sum + item.quantity,
                0
            );

        cart.totalAmount =
            cart.items.reduce(
                (sum, item) =>
                    sum + item.subtotal,
                0
            );
    }

    private generateExpiration() {
        return new Date(
            Date.now() +
            15 *
            60 *
            1000
        );
    }
}

