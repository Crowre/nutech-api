// routes/bannerRoutes.js
import express from 'express';
import { getBanners } from '../controllers/bannerController.js';

const router = express.Router();

// Public route - tidak memerlukan token
router.get('/', getBanners);

export default router;