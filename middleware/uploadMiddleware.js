// middleware/uploadMiddleware.js
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { errorResponse } from '../utils/responseHelper.js';

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = 'uploads/profile-images/';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname);
        cb(null, 'profile-' + uniqueSuffix + ext);
    }
});

const fileFilter = (req, file, cb) => {
    const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png'];

    if (allowedMimeTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error('FORMAT_ERROR'), false);
    }
};

const upload = multer({
    storage,
    fileFilter,
    limits: {
        fileSize: 2 * 1024 * 1024 // 2MB
    }
});

export const uploadProfileImage = (req, res, next) => {
    upload.single('profile_image')(req, res, (err) => {
        if (err) {
            if (err.message === 'FORMAT_ERROR' || err.code === 'LIMIT_FILE_SIZE') {
                return errorResponse(res, 'Format Image tidak sesuai');
            }
            return errorResponse(res, 'Format Image tidak sesuai');
        }
        next();
    });
};