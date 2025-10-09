// routes/transactionRouter.js
import express from 'express';
import { createTransaction } from '../controllers/transactionController.js'; // PERBAIKI
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/', authenticateToken, createTransaction);

export default router;