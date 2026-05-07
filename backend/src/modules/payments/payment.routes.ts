import { Router } from "express";

import { PaymentController } from "./payment.controller";

import { asyncHandler } from "../../shared/helpers/asyncHandler";

const router = Router();

const paymentController =
    new PaymentController();

router.post(
    "/payhere/webhook",

    asyncHandler(
        paymentController.payHereWebhook
    )
);

router.post(
    "/payhere/:bookingId",

    asyncHandler(
        paymentController.initializePayHerePayment
    )
);

router.get(
    "/payhere/page/:bookingId",

    asyncHandler(
        paymentController.renderPayHerePage
    )
);

export default router;