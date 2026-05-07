import { Router } from "express";
import { UserController } from "./user.controller";
import { asyncHandler } from "../../shared/helpers/asyncHandler";

const router = Router();
const userController = new UserController();

// router.get("/",
//     asyncHandler(userController.getUsers)
// );

router.post("/",
    asyncHandler(userController.createUser)
);

export default router;