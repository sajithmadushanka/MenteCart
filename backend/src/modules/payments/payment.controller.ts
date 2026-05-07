import {
    Request,
    Response,
} from "express";

import { PaymentService } from "./payment.service";


import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { successResponse } from "../../shared/responses/apiResponses";

export class PaymentController {
    private paymentService =
        new PaymentService();

    payHereWebhook = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        await this.paymentService.handlePayHereWebhook(
            req.body
        );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                null,
                "Webhook processed"
            )
        );
    };

    initializePayHerePayment =
        async (
            req: Request,
            res: Response
        ): Promise<void> => {
            const id = Array.isArray(req.params.bookingId) ? req.params.bookingId[0] : req.params.bookingId;
            const payload =
                await this.paymentService.initializePayHerePayment(
                    id
                );

            res.status(HTTP_STATUS.OK).json(
                successResponse(
                    payload,
                    "PayHere payment initialized"
                )
            );
        };


    renderPayHerePage =
        async (
            req: Request,
            res: Response
        ) => {
            const {
                bookingId,
            } = req.params;

            const id = Array.isArray(bookingId) ? bookingId[0] : bookingId;

            const paymentData =
                await this.paymentService.initializePayHerePayment(
                    id
                );

            const paymentPage =
                this.paymentService.generatePayHereHtmlPage(
                    paymentData
                );

            res.send(
                paymentPage
            );
        };
}