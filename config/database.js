// -------------------------------------------------------------------

import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 5432,
    ssl: {
        rejectUnauthorized: false // jika pakai Neon atau SSL remote
    },
    // ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false, //untuk postgresql local
    max: 10, // connection limit
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000
};

const pool = new Pool(dbConfig);

pool.connect()
    .then(client => {
        console.log('Database connected successfully');
        console.log('DB Config:', dbConfig);
        client.release();
    })
    .catch(err => {
        console.error('Database connection failed:', err);
    });

export default pool;
