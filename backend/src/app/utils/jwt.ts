import jwt, {
  Secret,
  SignOptions,
} from "jsonwebtoken";

import { env } from "../../app/config/env";

import {
  AccessTokenPayload,
  RefreshTokenPayload,
} from "../../modules/auth/auth.types";

export const generateAccessToken = (
  payload: AccessTokenPayload
): string => {
  return jwt.sign(
    payload,
    env.jwt.accessSecret as Secret,
    {
      expiresIn:
        env.jwt.accessExpiresIn,
    } as SignOptions
  );
};

export const generateRefreshToken = (
  payload: RefreshTokenPayload
): string => {
  return jwt.sign(
    payload,
    env.jwt.refreshSecret as Secret,
    {
      expiresIn:
        env.jwt.refreshExpiresIn,
    } as SignOptions
  );
};

export const verifyAccessToken = (
  token: string
): AccessTokenPayload => {
  return jwt.verify(
    token,
    env.jwt.accessSecret
  ) as AccessTokenPayload;
};

export const verifyRefreshToken = (
  token: string
): RefreshTokenPayload => {
  return jwt.verify(
    token,
    env.jwt.refreshSecret
  ) as RefreshTokenPayload;
};


export const generateTokenPair = (
  accessPayload: AccessTokenPayload,
  refreshPayload: RefreshTokenPayload
) => {
  return {
    accessToken:
      generateAccessToken(accessPayload),

    refreshToken:
      generateRefreshToken(refreshPayload),
  };
};