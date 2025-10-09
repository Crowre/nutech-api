// controllers/transactionController.js
import db from '../config/database.js';
import { successResponse, errorResponse, serverError } from '../utils/responseHelper.js';

export const createTransaction = async (req, res) => {
    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();

        const { service_code } = req.body;
        const userEmail = req.user.email;

        console.log('💳 Transaction request:', { userEmail, service_code });

        if (!service_code) {
            await connection.rollback();
            return errorResponse(res, 'Service atau Layanan tidak ditemukan');
        }

        // Check service
        const [services] = await connection.execute(
            'SELECT service_code, service_name, service_tariff FROM services WHERE service_code = ? AND is_active = TRUE',
            [service_code]
        );

        if (services.length === 0) {
            await connection.rollback();
            return errorResponse(res, 'Service atau Layanan tidak ditemukan');
        }

        const service = services[0];
        const transactionAmount = service.service_tariff;

        // Check balance
        const [balances] = await connection.execute(
            'SELECT balance FROM balances WHERE email = ? FOR UPDATE',
            [userEmail]
        );

        if (balances.length === 0) {
            await connection.rollback();
            return errorResponse(res, 'Balance tidak ditemukan', 404, 106);
        }

        const currentBalance = balances[0].balance;

        if (currentBalance < transactionAmount) {
            await connection.rollback();
            return errorResponse(res, 'Saldo tidak mencukupi', 400, 107);
        }

        const newBalance = currentBalance - transactionAmount;

        // Update balance
        await connection.execute(
            'UPDATE balances SET balance = ? WHERE email = ?',
            [newBalance, userEmail]
        );

        // Generate invoice_number HANYA untuk PAYMENT
        const now = new Date();
        const invoiceNumber = `INV-${now.getTime()}-${Math.floor(1000 + Math.random() * 9000)}`;

        // Record transaction DENGAN invoice_number untuk PAYMENT
        await connection.execute(
            `INSERT INTO transactions 
             (invoice_number, email, service_code, service_name, transaction_type, total_amount, created_on) 
             VALUES (?, ?, ?, ?, 'PAYMENT', ?, NOW())`,
            [invoiceNumber, userEmail, service_code, service.service_name, transactionAmount]
        );

        await connection.commit();

        console.log('✅ Payment successful:', { invoiceNumber, service_code });

        return successResponse(res, {
            invoice_number: invoiceNumber,
            service_code: service_code,
            service_name: service.service_name,
            transaction_type: 'PAYMENT',
            total_amount: transactionAmount,
            created_on: now.toISOString()
        }, 'Transaksi berhasil');

    } catch (error) {
        await connection.rollback();
        console.error('❌ Transaction error:', error);
        return serverError(res, error);
    } finally {
        connection.release();
    }
};