import { Types } from "mongoose";

import { CartModel } from "./cart.model";

import {
    CartDocument,
    CartItem,
} from "./cart.types";

export class CartRepository {
    async findByUserId(
        userId: string
    ) {
        return CartModel.findOne({
            userId,
        }).exec();
    }
    findCartItem(
        cart: CartDocument,
        itemId: string
    ) {
        return cart.items.find(
            (item: any) => item.id === itemId
        );
    }
    async createCart(
        userId: string
    ) {
        return CartModel.create({
            userId:
                new Types.ObjectId(userId),

            items: [],

            totalItems: 0,

            totalAmount: 0,
        });
    }
    async saveCart(
        cart: CartDocument & {
            _id: Types.ObjectId;
        }
    ) {
        return CartModel.findByIdAndUpdate(cart._id, cart, { returnDocument: "after" }).exec();
    }

    removeCartItem(
        cart: CartDocument,
        itemId: string
    ) {
        cart.items =
            cart.items.filter(
                (item) =>
                    item._id?.toString() !==
                    itemId
            );

        return cart;
    }
    clearCart(
        cart: CartDocument
    ) {
        cart.items = [];

        cart.totalItems = 0;

        cart.totalAmount = 0;

        return cart;
    }
}