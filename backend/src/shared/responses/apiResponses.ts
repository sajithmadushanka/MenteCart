export interface SuccessResponse<T> {
    success: true;

    message: string;

    data: T;

    meta?: Record<string, unknown>;
}

export interface ErrorResponse {
    success: false;

    message: string;

    errorCode?: string;

    errors?: unknown;

    statusCode: number;
}

export const successResponse = <T>(
    data: T,
    message = "Success",
    meta?: Record<string, unknown>
): SuccessResponse<T> => {
    return {
        success: true,
        message,
        data,
        meta,
    };
};

export const errorResponse = (
    statusCode = 500,
    message = "Something went wrong",
    errorCode?: string,
    errors?: unknown
): ErrorResponse => {
    return {
        success: false,
        statusCode,
        message,
        errorCode,
        errors,
    };
};