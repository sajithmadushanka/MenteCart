import {
    ClientSession,
    QueryFilter,
    Types,
} from "mongoose";

import { UserModel } from "./user.model";

import { UserDocument } from "./user.types";

export class UserRepository {
    async create(
        payload: Partial<UserDocument>,
        session?: ClientSession
    ): Promise<
        UserDocument & {
            _id: Types.ObjectId;
        }
    > {
        const users =
            await UserModel.create(
                [payload],
                {
                    session,
                }
            );

        return users[0];
    }

    async findByEmail(email: string) {
        return UserModel.findOne({
            email,
        })
            .select("+password")
            .exec();
    }

    async findById(userId: string) {
        return UserModel.findById(userId).exec();
    }

    async exists(
        filter: QueryFilter<UserDocument>
    ): Promise<boolean> {
        const result =
            await UserModel.exists(filter);

        return Boolean(result);
    }

    async findActiveById(userId: string) {
        return UserModel.findOne({
            _id: userId,

            isActive: true,
        }).exec();
    }
}