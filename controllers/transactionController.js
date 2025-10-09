// controllers/transactionController.js
import db from '../config/database.js';
import { successResponse, errorResponse, serverError } from '../utils/responseHelper.js';

// export const createTransaction = async (req, res) => {
//     const connection = await db.getConnection();

//     try {
//         await connection.beginTransaction();

//         const { service_code } = req.body;
//         const userEmail = req.user.email;

//         console.log('💳 Transaction request:', { userEmail, service_code });

//         if (!service_code) {
//             await connection.rollback();
//             return errorResponse(res, 'Service atau Layanan tidak ditemukan');
//         }

//         // Check service
//         const [services] = await connection.execute(
//             'SELECT service_code, service_name, service_tariff FROM services WHERE service_code = ? AND is_active = TRUE',
//             [service_code]
//         );

//         if (services.length === 0) {
//             await connection.rollback();
//             return errorResponse(res, 'Service atau Layanan tidak ditemukan');
//         }

//         const service = services[0];
//         const transactionAmount = service.service_tariff;

//         // Check balance
//         const [balances] = await connection.execute(
//             'SELECT balance FROM balances WHERE email = ? FOR UPDATE',
//             [userEmail]
//         );

//         if (balances.length === 0) {
//             await connection.rollback();
//             return errorResponse(res, 'Balance tidak ditemukan', 404, 106);
//         }

//         const currentBalance = balances[0].balance;

//         if (currentBalance < transactionAmount) {
//             await connection.rollback();
//             return errorResponse(res, 'Saldo tidak mencukupi', 400, 107);
//         }

//         const newBalance = currentBalance - transactionAmount;

//         // Update balance
//         await connection.execute(
//             'UPDATE balances SET balance = ? WHERE email = ?',
//             [newBalance, userEmail]
//         );

//         // Generate invoice_number HANYA untuk PAYMENT
//         const now = new Date();
//         const invoiceNumber = `INV-${now.getTime()}-${Math.floor(1000 + Math.random() * 9000)}`;

//         // Record transaction DENGAN invoice_number untuk PAYMENT
//         await connection.execute(
//             `INSERT INTO transactions 
//              (invoice_number, email, service_code, service_name, transaction_type, total_amount, created_on) 
//              VALUES (?, ?, ?, ?, 'PAYMENT', ?, NOW())`,
//             [invoiceNumber, userEmail, service_code, service.service_name, transactionAmount]
//         );

//         await connection.commit();

//         console.log('✅ Payment successful:', { invoiceNumber, service_code });

//         return successResponse(res, {
//             invoice_number: invoiceNumber,
//             service_code: service_code,
//             service_name: service.service_name,
//             transaction_type: 'PAYMENT',
//             total_amount: transactionAmount,
//             created_on: now.toISOString()
//         }, 'Transaksi berhasil');

//     } catch (error) {
//         await connection.rollback();
//         console.error('❌ Transaction error:', error);
//         return serverError(res, error);
//     } finally {
//         connection.release();
//     }
// };

export const createTransaction = async (req, res) => {
    const client = await db.connect(); // PostgreSQL pakai connect() bukan getConnection()

    try {
        await client.query('BEGIN');

        const { service_code } = req.body;
        const userEmail = req.user.email;

        console.log('💳 Transaction request:', { userEmail, service_code });

        if (!service_code) {
            await client.query('ROLLBACK');
            return errorResponse(res, 'Service atau Layanan tidak ditemukan');
        }

        // Cek service aktif
        const servicesResult = await client.query(
            `SELECT service_code, service_name, service_tariff 
             FROM services 
             WHERE service_code = $1 AND is_active = TRUE`,
            [service_code]
        );

        if (servicesResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return errorResponse(res, 'Service atau Layanan tidak ditemukan');
        }

        const service = servicesResult.rows[0];
        const transactionAmount = service.service_tariff;

        // Cek balance user dan lock barisnya
        const balancesResult = await client.query(
            `SELECT balance FROM balances WHERE email = $1 FOR UPDATE`,
            [userEmail]
        );

        if (balancesResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return errorResponse(res, 'Balance tidak ditemukan', 404, 106);
        }

        const currentBalance = balancesResult.rows[0].balance;

        if (currentBalance < transactionAmount) {
            await client.query('ROLLBACK');
            return errorResponse(res, 'Saldo tidak mencukupi', 400, 107);
        }

        const newBalance = currentBalance - transactionAmount;

        // Update saldo
        await client.query(
            `UPDATE balances SET balance = $1 WHERE email = $2`,
            [newBalance, userEmail]
        );

        // Generate invoice_number
        const now = new Date();
        const invoiceNumber = `INV-${now.getTime()}-${Math.floor(1000 + Math.random() * 9000)}`;

        // Simpan transaksi
        await client.query(
            `INSERT INTO transactions 
             (invoice_number, email, service_code, service_name, transaction_type, total_amount, created_on) 
             VALUES ($1, $2, $3, $4, 'PAYMENT', $5, CURRENT_TIMESTAMP)`,
            [invoiceNumber, userEmail, service_code, service.service_name, transactionAmount]
        );

        await client.query('COMMIT');

        console.log('Payment successful:', { invoiceNumber, service_code });

        return successResponse(res, {
            invoice_number: invoiceNumber,
            service_code: service_code,
            service_name: service.service_name,
            transaction_type: 'PAYMENT',
            total_amount: transactionAmount,
            created_on: now.toISOString()
        }, 'Transaksi berhasil');

    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Transaction error:', error);
        return serverError(res, error);
    } finally {
        client.release(); // Lepas koneksi ke pool
    }
};
