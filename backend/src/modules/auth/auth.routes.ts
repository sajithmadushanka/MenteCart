import { Router } from "express";

import { AuthController } from "./auth.controller";

import { validate } from "../../app/middleware/validate.middleware";



import { asyncHandler } from "../../shared/helpers/asyncHandler";
import { loginSchema, signupSchema } from "../users/user.validation";
import { authMiddleware } from "../../app/middleware/auth.middleware";
import { logoutSchema, refreshTokenSchema } from "./auth.validation";

const router = Router();

const authController =
    new AuthController();

router.post(
    "/signup",

    validate(signupSchema),

    asyncHandler(
        authController.signup
    )
);
router.post(
    "/login",

    validate(loginSchema),

    asyncHandler(
        authController.login
    )
);

router.get(
    "/me",

    authMiddleware,

    asyncHandler(
        authController.me
    )
); router.post(
    "/refresh",

    validate(refreshTokenSchema),

    asyncHandler(
        authController.refreshToken
    )
);

router.post(
    "/logout",

    validate(logoutSchema),

    asyncHandler(
        authController.logout
    )
);
router.post(
    "/logout-all",

    authMiddleware,

    asyncHandler(
        authController.logoutAllDevices
    )
);
export default router;