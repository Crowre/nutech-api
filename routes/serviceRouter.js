// routes/serviceRouter.js
import express from 'express';
import { getServices } from '../controllers/serviceController.js'; // PERBAIKI
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.get('/', authenticateToken, getServices);

export default router;