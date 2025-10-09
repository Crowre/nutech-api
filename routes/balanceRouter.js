// routes/balanceRouter.js
import express from 'express';
import { getBalance, topUpBalance } from '../controllers/balanceController.js'; // PERBAIKI
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.get('/', authenticateToken, getBalance);
router.post('/topup', authenticateToken, topUpBalance);

export default router;