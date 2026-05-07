import { UserRepository } from "./user.repository";

const userRepository = new UserRepository();

export class UserService {
    async getUsers() {
        // return userRepository.findAll();
    }


    async createUser(data: {
        name: string;
        email: string;
    }) {
        return userRepository.create(data);
    }
}