import md5 from "crypto-js/md5";

import crypto from "crypto";

export const generatePayHereHash = ({
    merchantId, orderId, amount, currency, merchantSecret
}: {
    merchantId: string;
    orderId: string;
    amount: string;
    currency: string;
    merchantSecret: string;
}) => {
    const hashedSecret = crypto
        .createHash("md5")
        .update(merchantSecret)
        .digest("hex")
        .toUpperCase();

    return crypto
        .createHash("md5")
        .update(merchantId + orderId + amount + currency + hashedSecret)
        .digest("hex")
        .toUpperCase();
};

export const generatePayHereWebhookHash =
    ({
        merchantId,
        orderId,
        amount,
        currency,
        statusCode,
        merchantSecret,
    }: {
        merchantId: string;

        orderId: string;

        amount: string;

        currency: string;

        statusCode: string;

        merchantSecret: string;
    }) => {
        const hashedSecret =
            md5(merchantSecret)
                .toString()
                .toUpperCase();

        return md5(
            merchantId +
            orderId +
            amount +
            currency +
            statusCode +
            hashedSecret
        )
            .toString()
            .toUpperCase();
    };