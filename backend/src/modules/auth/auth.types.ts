import { UserRole } from "./auth.enums";

export interface AccessTokenPayload {
    userId: string;

    email: string;

    role: UserRole;
}

export interface RefreshTokenPayload {
    sessionId: string;

    userId: string;
}

export interface AuthUser {
    id: string;

    name: string;

    email: string;

    role: UserRole;
}


export interface AuthTokens {
    accessToken: string;

    refreshToken: string;
}

export interface AuthResponse {
    user: AuthUser;

    tokens: AuthTokens;
}