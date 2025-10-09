// controllers/historyController.js
import db from '../config/database.js';
import { successResponse, serverError } from '../utils/responseHelper.js';

export const getTransactionHistory = async (req, res) => {
    try {
        const userEmail = req.user.email;
        const { limit } = req.query;

        console.log('📋 History request:', { userEmail, limit });

        let query = `
            SELECT 
                invoice_number,
                transaction_type, 
                service_name as description,
                total_amount, 
                created_on 
            FROM transactions 
            WHERE email = ? 
            ORDER BY created_on DESC
        `;

        let queryParams = [userEmail];

        if (limit && !isNaN(limit) && limit > 0) {
            query += ' LIMIT ?';
            queryParams.push(parseInt(limit));
        }

        const [transactions] = await db.execute(query, queryParams);

        const [countResult] = await db.execute(
            'SELECT COUNT(*) as total FROM transactions WHERE email = ?',
            [userEmail]
        );

        const totalRecords = countResult[0].total;
        const appliedLimit = limit ? parseInt(limit) : totalRecords;

        // Format response - generate invoice_number untuk TOPUP yang NULL
        const records = transactions.map(transaction => {
            let invoiceNumber = transaction.invoice_number;

            // Jika invoice_number NULL (TOPUP), generate berdasarkan ID/timestamp
            if (!invoiceNumber && transaction.transaction_type === 'TOPUP') {
                const date = new Date(transaction.created_on);
                invoiceNumber = `TOPUP-${date.toISOString().slice(0, 10).replace(/-/g, '')}`;
            }

            return {
                invoice_number: invoiceNumber,
                transaction_type: transaction.transaction_type,
                description: transaction.description,
                total_amount: transaction.total_amount,
                created_on: transaction.created_on
            };
        });

        return successResponse(res, {
            offset: 0,
            limit: appliedLimit,
            records: records,
            total: totalRecords
        }, 'Get History Berhasil');

    } catch (error) {
        return serverError(res, error);
    }
};