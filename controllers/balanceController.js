// controllers/balanceController.js
import db from '../config/database.js';
import { successResponse, errorResponse, serverError } from '../utils/responseHelper.js';

// export const getBalance = async (req, res) => {
//     try {
//         const userEmail = req.user.email;

//         const [balances] = await db.execute(
//             'SELECT balance FROM balances WHERE email = ?',
//             [userEmail]
//         );

//         if (balances.length === 0) {
//             return errorResponse(res, 'Balance tidak ditemukan', 404, 106);
//         }

//         return successResponse(res, {
//             balance: balances[0].balance
//         }, 'Get Balance Berhasil');

//     } catch (error) {
//         return serverError(res, error);
//     }
// };

export const getBalance = async (req, res) => {
    try {
        const userEmail = req.user.email;

        const result = await db.query(
            'SELECT balance FROM balances WHERE email = $1',
            [userEmail]
        );

        if (result.rows.length === 0) {
            return errorResponse(res, 'Balance tidak ditemukan', 404, 106);
        }

        return successResponse(res, {
            balance: result.rows[0].balance
        }, 'Get Balance Berhasil');

    } catch (error) {
        return serverError(res, error);
    }
};


// export const topUpBalance = async (req, res) => {
//     const connection = await db.getConnection();

//     try {
//         await connection.beginTransaction();

//         const { top_up_amount } = req.body;
//         const userEmail = req.user.email;

//         console.log('💰 Topup request:', { userEmail, top_up_amount });

//         // Validasi input
//         if (typeof top_up_amount !== 'number' || top_up_amount < 1) {
//             await connection.rollback();
//             return errorResponse(res, 'Parameter amount hanya boleh angka dan tidak boleh lebih kecil dari 0');
//         }

//         // Cek atau buat balance record
//         const [balances] = await connection.execute(
//             'SELECT balance FROM balances WHERE email = ? FOR UPDATE',
//             [userEmail]
//         );

//         let currentBalance = 0;

//         if (balances.length === 0) {
//             await connection.execute(
//                 'INSERT INTO balances (email, balance) VALUES (?, ?)',
//                 [userEmail, 0]
//             );
//             console.log('✅ Created new balance record for:', userEmail);
//         } else {
//             currentBalance = balances[0].balance;
//         }

//         // Hitung balance baru
//         const newBalance = currentBalance + top_up_amount;

//         // Update balance
//         await connection.execute(
//             'UPDATE balances SET balance = ? WHERE email = ?',
//             [newBalance, userEmail]
//         );

//         // Catat transaksi TOPUP TANPA invoice_number (NULL)
//         await connection.execute(
//             `INSERT INTO transactions 
//              (email, service_code, service_name, transaction_type, total_amount, created_on) 
//              VALUES (?, ?, ?, ?, ?, NOW())`,
//             [userEmail, 'TOPUP', 'Top Up Balance', 'TOPUP', top_up_amount]
//         );

//         await connection.commit();

//         console.log('✅ Topup successful. New balance:', newBalance);

//         return successResponse(res, {
//             balance: newBalance
//         }, 'Top Up Balance berhasil');

//     } catch (error) {
//         await connection.rollback();
//         console.error('❌ Topup error:', error);
//         return serverError(res, error);
//     } finally {
//         connection.release();
//     }
// };

export const topUpBalance = async (req, res) => {
    const client = await db.connect();

    try {
        await client.query('BEGIN');

        const { top_up_amount } = req.body;
        const userEmail = req.user.email;

        console.log('💰 Topup request:', { userEmail, top_up_amount });

        // Validasi input
        if (typeof top_up_amount !== 'number' || top_up_amount < 1) {
            await client.query('ROLLBACK');
            return errorResponse(res, 'Parameter amount hanya boleh angka dan tidak boleh lebih kecil dari 0');
        }

        // Cek atau buat balance record
        const balances = await client.query(
            'SELECT balance FROM balances WHERE email = $1 FOR UPDATE',
            [userEmail]
        );

        let currentBalance = 0;

        if (balances.rows.length === 0) {
            await client.query(
                'INSERT INTO balances (email, balance) VALUES ($1, $2)',
                [userEmail, 0]
            );
            console.log('Created new balance record for:', userEmail);
        } else {
            currentBalance = balances.rows[0].balance;
        }

        // Hitung balance baru
        const newBalance = currentBalance + top_up_amount;

        // Update balance
        await client.query(
            'UPDATE balances SET balance = $1 WHERE email = $2',
            [newBalance, userEmail]
        );

        // Catat transaksi TOPUP (tanpa invoice_number)
        await client.query(
            `INSERT INTO transactions 
             (email, service_code, service_name, transaction_type, total_amount, created_on) 
             VALUES ($1, $2, $3, $4, $5, NOW())`,
            [userEmail, 'TOPUP', 'Top Up Balance', 'TOPUP', top_up_amount]
        );

        await client.query('COMMIT');

        console.log('Topup successful. New balance:', newBalance);

        return successResponse(res, {
            balance: newBalance
        }, 'Top Up Balance berhasil');

    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Topup error:', error);
        return serverError(res, error);
    } finally {
        client.release(); // lepas koneksi ke pool
    }
};
