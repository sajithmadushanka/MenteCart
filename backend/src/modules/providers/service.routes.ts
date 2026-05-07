import { Router } from "express";

import { ServiceController } from "./service.controller";

import {
    createServiceSchema,
    updateServiceSchema,
    serviceQuerySchema,
    serviceIdParamSchema,
} from "./service.validation";

import { validate } from "../../app/middleware/validate.middleware";

import { asyncHandler } from "../../shared/helpers/asyncHandler";

import { authMiddleware } from "../../app/middleware/auth.middleware";

import { authorize } from "../../app/middleware/authorize.middleware";

import { UserRole } from "../auth/auth.enums";

const router = Router();

const serviceController =
    new ServiceController();

router.get(
    "/",

    validate(serviceQuerySchema),

    asyncHandler(
        serviceController.getServices
    )
);

router.get(
    "/:id",

    validate(serviceIdParamSchema),

    asyncHandler(
        serviceController.getServiceById
    )
);

router.post(
    "/",

    authMiddleware,

    authorize(UserRole.ADMIN),

    validate(createServiceSchema),

    asyncHandler(
        serviceController.createService
    )
);

router.patch(
    "/:id",

    authMiddleware,

    authorize(UserRole.ADMIN),

    validate(serviceIdParamSchema),

    validate(updateServiceSchema),

    asyncHandler(
        serviceController.updateService
    )
);

router.delete(
    "/:id",

    authMiddleware,

    authorize(UserRole.ADMIN),

    validate(serviceIdParamSchema),

    asyncHandler(
        serviceController.deactivateService
    )
);

export default router;