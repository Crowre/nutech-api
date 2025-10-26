-- =============================================
-- Database: nutech_db
-- Compatible with PostgreSQL
-- =============================================

-- Step 1: Create database
CREATE DATABASE nutech_db;
\c nutech_db;

-- =============================================
-- Table: users
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_image TEXT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from users;
select * from balances;
select * from services;
select * from banners;
select * from transactions;
-- =============================================
-- Table: balances
-- =============================================
CREATE TABLE IF NOT EXISTS balances (
    email VARCHAR(255) PRIMARY KEY REFERENCES users(email) ON DELETE CASCADE,
    balance INTEGER DEFAULT 0,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Table: services
-- =============================================
CREATE TABLE IF NOT EXISTS services (
    id SERIAL PRIMARY KEY,
    service_code VARCHAR(50) UNIQUE NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    service_icon VARCHAR(500) NOT NULL,
    service_tariff INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Table: banners
-- =============================================
CREATE TABLE IF NOT EXISTS banners (
    id SERIAL PRIMARY KEY,
    banner_name VARCHAR(255) NOT NULL,
    banner_image VARCHAR(500) NOT NULL,
    description TEXT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Table: transactions
-- =============================================
CREATE TYPE transaction_type_enum AS ENUM ('TOPUP', 'PAYMENT');

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) NULL,
    email VARCHAR(255) NOT NULL REFERENCES users(email) ON DELETE CASCADE,
    service_code VARCHAR(50) NULL,
    service_name VARCHAR(255) NULL,
    transaction_type transaction_type_enum NOT NULL,
    total_amount INTEGER NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- INDEXES
-- =============================================
CREATE INDEX idx_transactions_email ON transactions(email);
CREATE INDEX idx_transactions_created_on ON transactions(created_on);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);
CREATE INDEX idx_invoice_number ON transactions(invoice_number);

CREATE INDEX idx_services_active ON services(is_active);
CREATE INDEX idx_services_code ON services(service_code);

CREATE INDEX idx_banners_active ON banners(is_active);

-- =============================================
-- SAMPLE DATA
-- =============================================

INSERT INTO services (service_code, service_name, service_icon, service_tariff) VALUES
('PAJAK', 'Pajak PBB', 'https://nutech-integrasi.app/dummy.jpg', 40000),
('PLN', 'Listrik', 'https://nutech-integrasi.app/dummy.jpg', 10000),
('PDAM', 'PDAM Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 40000),
('PULSA', 'Pulsa', 'https://nutech-integrasi.app/dummy.jpg', 40000),
('PGN', 'PGN Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000),
('MUSIK', 'Musik Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000),
('TV', 'TV Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000),
('PAKET_DATA', 'Paket data', 'https://nutech-integrasi.app/dummy.jpg', 50000),
('VOUCHER_GAME', 'Voucher Game', 'https://nutech-integrasi.app/dummy.jpg', 100000),
('VOUCHER_MAKANAN', 'Voucher Makanan', 'https://nutech-integrasi.app/dummy.jpg', 100000),
('QURBAN', 'Qurban', 'https://nutech-integrasi.app/dummy.jpg', 200000),
('ZAKAT', 'Zakat', 'https://nutech-integrasi.app/dummy.jpg', 300000);

INSERT INTO banners (banner_name, banner_image, description) VALUES
('Banner 1', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet'),
('Banner 2', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet'),
('Banner 3', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet'),
('Banner 4', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet'),
('Banner 5', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet'),
('Banner 6', 'https://nutech-integrasi.app/dummy.jpg', 'Lorem Ipsum Dolor sit amet');


INSERT INTO balances (email, balance) VALUES
('wildan123@gmail.com', 50000),
('wanda123@gmail.com', 0),
('test@example.com', 100000);

INSERT INTO transactions (invoice_number, email, service_code, service_name, transaction_type, total_amount, created_on) VALUES
('INV-20231201-001', 'wildan123@gmail.com', 'PLN', 'Listrik', 'PAYMENT', 10000, '2023-12-01 10:00:00'),
('INV-20231201-002', 'wildan123@gmail.com', 'PULSA', 'Pulsa', 'PAYMENT', 40000, '2023-12-01 11:00:00'),
(NULL, 'wildan123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 100000, '2023-12-01 09:00:00'),
('INV-20231202-001', 'wanda123@gmail.com', 'PDAM', 'PDAM Berlangganan', 'PAYMENT', 40000, '2023-12-02 14:00:00'),
(NULL, 'wanda123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 50000, '2023-12-02 13:00:00');
