// middleware/authMiddleware.js
import jwt from 'jsonwebtoken';
import db from '../config/database.js';
import { errorResponse } from '../utils/responseHelper.js';

// export const authenticateToken = async (req, res, next) => {
//     const authHeader = req.headers['authorization'];
//     const token = authHeader?.split(' ')[1];

//     if (!token) {
//         return errorResponse(res, 'Token tidak tidak valid atau kadaluwarsa', 401, 108);
//     }

//     try {
//         const decoded = jwt.verify(token, process.env.JWT_SECRET);

//         const [users] = await db.execute(
//             'SELECT email, first_name, last_name, profile_image FROM users WHERE email = ?',
//             [decoded.email]
//         );

//         if (users.length === 0) {
//             return errorResponse(res, 'Token tidak tidak valid atau kadaluwarsa', 401, 108);
//         }

//         req.user = users[0];
//         next();
//     } catch (error) {
//         return errorResponse(res, 'Token tidak tidak valid atau kadaluwarsa', 401, 108);
//     }
// };

export const authenticateToken = async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader?.split(' ')[1];

    if (!token) {
        return errorResponse(res, 'Token tidak valid atau kadaluwarsa', 401, 108);
    }

    try {
        // Verifikasi token JWT
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        const users = await db.query(
            'SELECT email, first_name, last_name, profile_image FROM users WHERE email = $1',
            [decoded.email]
        );

        if (users.rows.length === 0) {
            return errorResponse(res, 'Token tidak valid atau kadaluwarsa', 401, 108);
        }

        // Simpan data user ke request
        req.user = users.rows[0];
        next();

    } catch (error) {
        return errorResponse(res, 'Token tidak valid atau kadaluwarsa', 401, 108);
    }
};


export default authenticateToken;