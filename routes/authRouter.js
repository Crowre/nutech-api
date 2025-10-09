// routes/authRouter.js
import express from 'express';
import { register, login } from '../controllers/authController.js'; // PERBAIKI
import { validateRegistration, validateLogin } from '../middleware/validationMiddleware.js';

const router = express.Router();

router.post('/registration', validateRegistration, register);
router.post('/login', validateLogin, login);

export default router;