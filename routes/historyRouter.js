// routes/historyRouter.js
import express from 'express';
import { getTransactionHistory } from '../controllers/historyController.js'; // PERBAIKI
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.get('/', authenticateToken, getTransactionHistory);

export default router;