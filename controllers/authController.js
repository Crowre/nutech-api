// controllers/authController.js
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import db from '../config/database.js';
import { successResponse, errorResponse, serverError } from '../utils/responseHelper.js';

export const register = async (req, res) => {
    try {
        const { email, password, first_name, last_name } = req.body;

        // Check if email exists
        const [existingUsers] = await db.execute(
            'SELECT email FROM users WHERE email = ?',
            [email]
        );

        if (existingUsers.length > 0) {
            return errorResponse(res, 'Email sudah terdaftar');
        }

        // Hash password and create user
        const hashedPassword = await bcrypt.hash(password, 10);

        await db.execute(
            'INSERT INTO users (email, password, first_name, last_name) VALUES (?, ?, ?, ?)',
            [email, hashedPassword, first_name, last_name]
        );

        // Create initial balance
        await db.execute(
            'INSERT INTO balances (email, balance) VALUES (?, ?)',
            [email, 0]
        );

        // Get created user
        const [users] = await db.execute(
            'SELECT email, first_name, last_name, profile_image FROM users WHERE email = ?',
            [email]
        );

        return successResponse(res, users[0], 'Registrasi berhasil silahkan login');

    } catch (error) {
        return serverError(res, error);
    }
};

export const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Find user
        const [users] = await db.execute(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (users.length === 0) {
            return errorResponse(res, 'Email atau password salah', 401, 103);
        }

        const user = users[0];

        // Check password
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return errorResponse(res, 'Email atau password salah', 401, 103);
        }

        // Generate token
        const token = jwt.sign(
            { email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        return successResponse(res, { token }, 'Login Sukses');

    } catch (error) {
        return serverError(res, error);
    }
};