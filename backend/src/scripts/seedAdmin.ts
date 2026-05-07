// first admin via seed
// future admins via admin panel


import { UserModel } from "../modules/users/user.model";

import { hashPassword } from "../app/utils/bcrypt";

import { UserRole } from "../modules/auth/auth.enums";
import { connectDB } from "../app/config/db";

const seedAdmin = async () => {
    try {
        await connectDB();

        const existingAdmin =
            await UserModel.findOne({
                email: "admin@mentecart.com",
            });

        if (existingAdmin) {
            console.log(
                "Admin already exists"
            );

            process.exit(0);
        }

        const hashedPassword =
            await hashPassword(
                "Admin123!"
            );

        await UserModel.create({
            name: "System Admin",

            email:
                "admin@mentecart.com",

            password:
                hashedPassword,

            role: UserRole.ADMIN,
        });

        console.log(
            "Admin created successfully"
        );

        process.exit(0);
    } catch (error) {
        console.error(error);

        process.exit(1);
    }
};

seedAdmin();