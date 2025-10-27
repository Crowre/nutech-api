// controllers/profileController.js
import db from '../config/database.js';
import fs from 'fs';
import path from 'path';
import { successResponse, errorResponse, serverError } from '../utils/responseHelper.js';

// Helper functions
const deleteOldProfileImage = async (imageUrl) => {
    try {
        const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

        if (imageUrl && imageUrl.startsWith(baseUrl)) {
            const filename = path.basename(imageUrl);
            const filePath = path.join('uploads', 'profile-images', filename);

            // Security validation
            if (!filename || filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
                console.warn('Invalid filename for deletion:', filename);
                return;
            }

            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
                console.log(`🗑️ Deleted old profile image: ${filename}`);
            }
        }
    } catch (error) {
        console.error('Error deleting old profile image:', error);
    }
};

const handleFileUpload = (file) => {
    return new Promise((resolve, reject) => {
        try {
            // File validation
            const allowedFormats = ['image/jpeg', 'image/jpg', 'image/png'];
            const allowedExtensions = ['.jpg', '.jpeg', '.png'];
            const fileExtension = path.extname(file.originalname).toLowerCase();

            if (!allowedFormats.includes(file.mimetype) ||
                !allowedExtensions.includes(fileExtension) ||
                file.size > 2 * 1024 * 1024) {
                fs.unlinkSync(file.path);     //program upload foto tidak bisa dieksekusi karena masih menggunakan server vercel yang memiliki keterbatasan untuk menyimpan file secara permanen
                reject(new Error('FORMAT_ERROR'));
                return;
            }

            const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
            const profileImageUrl = `${baseUrl}/profile-images/${file.filename}`;

            console.log(`✅ File uploaded: ${file.filename}`);
            resolve(profileImageUrl);
        } catch (error) {
            reject(error);
        }
    });
};

const validateUpdateFields = (first_name, last_name, hasFile) => {
    const hasTextFields = first_name || last_name;
    if (!hasTextFields && !hasFile) {
        throw new Error('INCOMPLETE_PARAMETERS');
    }
};

const getCurrentUser = async (email) => {
    const result = await db.query(
        'SELECT first_name, last_name, profile_image FROM users WHERE email = $1',
        [email]
    );

    if (result.rows.length === 0) {
        throw new Error('USER_NOT_FOUND');
    }

    return result.rows[0];
};

const updateUserProfile = async (email, firstName, lastName, profileImage) => {
    await db.query(
        'UPDATE users SET first_name = $1, last_name = $2, profile_image = $3 WHERE email = $4',
        [firstName, lastName, profileImage, email]
    );
};

const getUserProfile = async (email) => {
    const { rows } = await db.query(
        'SELECT email, first_name, last_name, profile_image FROM users WHERE email = $1',
        [email]
    );
    return rows[0];
};



// Main controller functions
export const getProfile = async (req, res) => {
    try {
        const userEmail = req.user.email;

        const user = await getUserProfile(userEmail);

        if (!user) {
            return errorResponse(res, 'User tidak ditemukan', 404, 108);
        }

        return successResponse(res, {
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            profile_image: user.profile_image
        });

    } catch (error) {
        return serverError(res, error);
    }
};

export const updateProfile = async (req, res) => {
    try {
        const userEmail = req.user.email;
        const { first_name, last_name } = req.body;

        console.log('📝 Update profile request:', { first_name, last_name, file: req.file?.filename });

        // Validate at least one field is provided
        validateUpdateFields(first_name, last_name, !!req.file);

        // Get current user data
        const currentUser = await getCurrentUser(userEmail);
        const oldProfileImage = currentUser.profile_image;

        let profileImageUrl = currentUser.profile_image;

        // Handle file upload if provided
        if (req.file) {
            profileImageUrl = await handleFileUpload(req.file);

            // Delete old profile image after successful upload
            if (oldProfileImage) {
                await deleteOldProfileImage(oldProfileImage);
            }
        }

        // Determine values to update
        const updateData = {
            firstName: first_name || currentUser.first_name,
            lastName: last_name || currentUser.last_name,
            profileImage: profileImageUrl
        };

        // Update user profile
        await updateUserProfile(userEmail, updateData.firstName, updateData.lastName, updateData.profileImage);

        // Get updated user data
        const updatedUser = await getUserProfile(userEmail);

        return successResponse(res, {
            email: updatedUser.email,
            first_name: updatedUser.first_name,
            last_name: updatedUser.last_name,
            profile_image: updatedUser.profile_image
        }, 'Update Profile berhasil');

    } catch (error) {
        // Clean up uploaded file if error occurs
        if (req.file?.path) {
            fs.unlinkSync(req.file.path);
        }

        // Handle specific errors
        // if (error.message === 'FORMAT_ERROR') {
        //     return errorResponse(res, 'Format Image tidak sesuai');
        // }
        // if (error.message === 'INCOMPLETE_PARAMETERS') {
        //     return errorResponse(res, 'Parameter tidak lengkap. Minimal satu field harus diupdate');
        // }
        // if (error.message === 'USER_NOT_FOUND') {
        //     return errorResponse(res, 'User tidak ditemukan', 404, 108);
        // }

        return serverError(res, error);
    }
};
