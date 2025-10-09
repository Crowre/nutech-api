// app.js
import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

// Routes
import authRoutes from './routes/authRouter.js';
import profileRoutes from './routes/profileRouter.js';
import balanceRoutes from './routes/balanceRouter.js';
import transactionRoutes from './routes/transactionRouter.js';
import bannerRoutes from './routes/bannerRouter.js';
import serviceRoutes from './routes/serviceRouter.js';
import historyRoutes from './routes/historyRouter.js';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Static files
app.use('/profile-images', express.static(path.join(__dirname, 'uploads', 'profile-images')));

// API Routes
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);
app.use('/balance', balanceRoutes);
app.use('/transaction', transactionRoutes);
app.use('/banner', bannerRoutes);
app.use('/service', serviceRoutes);
app.use('/history', historyRoutes);

// Health check
app.get('/', (req, res) => {
    res.json({ message: 'Server is running' });
});

// Error handling
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        status: 500,
        message: 'Internal server error',
        data: null
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});

export default app;