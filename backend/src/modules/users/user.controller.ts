import { Request, Response } from "express";
import { UserService } from "./user.service";
import { successResponse } from "../../shared/responses/apiResponses";

const userService = new UserService();

export class UserController {
    // async getUsers(req: Request, res: Response) {
    //     const users = await userService.getUsers();

    //     res.status(200).json(
    //         successResponse(users, "Users fetched")
    //     );
    // }

    async createUser(req: Request, res: Response) {
        const user = await userService.createUser(req.body);
        res.status(201).json(successResponse(user, "User created"));
    }
}