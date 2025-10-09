// utils/responseHelper.js
export const successResponse = (res, data, message = 'Sukses') => {
    return res.json({
        status: 0,
        message,
        data
    });
};

export const errorResponse = (res, message, statusCode = 400, errorCode = 102) => {
    return res.status(statusCode).json({
        status: errorCode,
        message,
        data: null
    });
};

export const serverError = (res, error) => {
    console.error('Server Error:', error);
    return res.status(500).json({
        status: 500,
        message: 'Internal server error',
        data: null
    });
};