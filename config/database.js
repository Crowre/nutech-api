// import mysql from 'mysql2/promise';
// import dotenv from 'dotenv

// dotenv.config();

// const dbConfig = {
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME,
//     port: process.env.DB_PORT || 3306,
//     waitForConnections: true,
//     connectionLimit: 10,
//     queueLimit: 0
// };

// const pool = mysql.createPool(dbConfig);

// pool.getConnection()
//     .then(connection => {
//         console.log('Database connected successfully');
//         connection.release();
//     })
//     .catch(err => {
//         console.error('Database connection failed:', err);
//     });


// export default pool;

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
    // ssl: {
    //     rejectUnauthorized: false // jika kamu pakai Neon atau SSL remote
    // },
    // ganti ssl ketika akan melakukan deployment
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
    max: 10, // connection limit
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000
};

const pool = new Pool(dbConfig);

pool.connect()
    .then(client => {
        console.log('Database connected successfully');
        client.release();
    })
    .catch(err => {
        console.error('Database connection failed:', err);
    });

export default pool;
