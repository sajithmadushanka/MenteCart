import {
    Request,
    Response,
} from "express";

import { CartService } from "./cart.service";


import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { successResponse } from "../../shared/responses/apiResponses";

export class CartController {
    private cartService =
        new CartService();

    getCart = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const cart =
            await this.cartService.getCart(
                req.user!.userId
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                cart,
                "Cart fetched successfully"
            )
        );
    };

    addItem = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const cart =
            await this.cartService.addItem(
                req.user!.userId,
                req.body
            );

        res.status(
            HTTP_STATUS.CREATED
        ).json(
            successResponse(
                cart,
                "Item added to cart"
            )
        );
    };

    updateItem = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id = Array.isArray(req.params.itemId) ? req.params.itemId[0] : req.params.itemId;
        const cart =
            await this.cartService.updateCartItem(
                req.user!.userId,
                id,
                req.body
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                cart,
                "Cart item updated"
            )
        );
    };

    removeItem = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id = Array.isArray(req.params.itemId) ? req.params.itemId[0] : req.params.itemId;
        const cart =
            await this.cartService.removeCartItem(
                req.user!.userId,
                id
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                cart,
                "Cart item removed"
            )
        );
    };

    clearCart = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        await this.cartService.clearCart(
            req.user!.userId
        );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                null,
                "Cart cleared successfully"
            )
        );
    };
}