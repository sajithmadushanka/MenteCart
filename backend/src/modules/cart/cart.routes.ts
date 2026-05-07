import { Router } from "express";

import { CartController } from "./cart.controller";

import {
    addCartItemSchema,
    updateCartItemSchema,
    cartItemParamSchema,
} from "./cart.validation";

import { authMiddleware } from "../../app/middleware/auth.middleware";

import { validate } from "../../app/middleware/validate.middleware";

import { asyncHandler } from "../../shared/helpers/asyncHandler";

const router = Router();

const cartController =
    new CartController();

router.use(authMiddleware);

router.get(
    "/",

    asyncHandler(
        cartController.getCart
    )
);

router.post(
    "/items",

    validate(addCartItemSchema),

    asyncHandler(
        cartController.addItem
    )
);

router.patch(
    "/items/:itemId",

    validate(cartItemParamSchema),

    validate(updateCartItemSchema),

    asyncHandler(
        cartController.updateItem
    )
);

router.delete(
    "/items/:itemId",

    validate(cartItemParamSchema),

    asyncHandler(
        cartController.removeItem
    )
);

router.delete(
    "/clear",

    asyncHandler(
        cartController.clearCart
    )
);

export default router;