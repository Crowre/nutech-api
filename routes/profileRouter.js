// routes/profileRouter.js
import express from 'express';
import { getProfile, updateProfile } from '../controllers/profileController.js'; // PERBAIKI
import { authenticateToken } from '../middleware/authMiddleware.js';
import { uploadProfileImage } from '../middleware/uploadMiddleware.js';

const router = express.Router();

router.get('/', authenticateToken, getProfile);
router.put('/update', authenticateToken, uploadProfileImage, updateProfile);

export default router;