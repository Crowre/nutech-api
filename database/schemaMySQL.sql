-- database/schema.sql
-- Nutech Integration API - Complete Database Schema
-- Version: 2.0
-- Created: 2024-01-01

-- Create database
CREATE DATABASE IF NOT EXISTS nutech_db;
USE nutech_db;

-- =============================================
-- Table: users
-- Stores user authentication and profile data
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_image TEXT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: balances  
-- Stores user balances with INTEGER type
-- =============================================
CREATE TABLE IF NOT EXISTS balances (
    email VARCHAR(255) PRIMARY KEY,
    balance INT DEFAULT 0,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: transactions
-- Stores all financial transactions
-- invoice_number can be NULL for TOPUP transactions
-- =============================================
CREATE TABLE IF NOT EXISTS transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(50) NULL,
    email VARCHAR(255) NOT NULL,
    service_code VARCHAR(50) NULL,
    service_name VARCHAR(255) NULL,
    transaction_type ENUM('TOPUP', 'PAYMENT') NOT NULL,
    total_amount INT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: services
-- Stores available PPOB payment services
-- =============================================
CREATE TABLE IF NOT EXISTS services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    service_code VARCHAR(50) UNIQUE NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    service_icon VARCHAR(500) NOT NULL,
    service_tariff INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: banners
-- Stores homepage banners for display
-- =============================================
CREATE TABLE IF NOT EXISTS banners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    banner_name VARCHAR(255) NOT NULL,
    banner_image VARCHAR(500) NOT NULL,
    description TEXT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- INDEXES for Performance Optimization
-- =============================================

-- Transactions table indexes
CREATE INDEX idx_transactions_email ON transactions(email);
CREATE INDEX idx_transactions_created_on ON transactions(created_on);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);
CREATE INDEX idx_invoice_number ON transactions(invoice_number);

-- Services table indexes  
CREATE INDEX idx_services_active ON services(is_active);
CREATE INDEX idx_services_code ON services(service_code);

-- Banners table indexes
CREATE INDEX idx_banners_active ON banners(is_active);

-- =============================================
-- SAMPLE DATA: Services
-- 12 default PPOB services as per requirements
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

-- =============================================
-- SAMPLE DATA: Banners
-- 6 sample banners for homepage
-- =============================================
INSERT INTO banners (banner_name, banner_image, description) VALUES
('Banner 1', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet'),
('Banner 2', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet'),
('Banner 3', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet'),
('Banner 4', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet'),
('Banner 5', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet'),
('Banner 6', 'https://nutech-integrasi.app/dummy.jpg', 'Lerem Ipsum Dolor sit amet');

-- =============================================
-- SAMPLE DATA: Test Users
-- Pre-created users for development and testing
-- =============================================
INSERT INTO users (email, password, first_name, last_name) VALUES
('wildan123@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Wildan', 'User'),
('wanda123@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Wanda', 'User'),
('test@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test', 'User');

-- =============================================
-- SAMPLE DATA: Initial Balances
-- Starting balances for test users
-- =============================================
INSERT INTO balances (email, balance) VALUES
('wildan123@gmail.com', 50000),
('wanda123@gmail.com', 0),
('test@example.com', 100000);

-- =============================================
-- SAMPLE DATA: Sample Transactions
-- Example transactions for testing history feature
-- =============================================
INSERT INTO transactions (invoice_number, email, service_code, service_name, transaction_type, total_amount, created_on) VALUES
('INV-20231201-001', 'wildan123@gmail.com', 'PLN', 'Listrik', 'PAYMENT', 10000, '2023-12-01 10:00:00'),
('INV-20231201-002', 'wildan123@gmail.com', 'PULSA', 'Pulsa', 'PAYMENT', 40000, '2023-12-01 11:00:00'),
(NULL, 'wildan123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 100000, '2023-12-01 09:00:00'),
('INV-20231202-001', 'wanda123@gmail.com', 'PDAM', 'PDAM Berlangganan', 'PAYMENT', 40000, '2023-12-02 14:00:00'),
(NULL, 'wanda123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 50000, '2023-12-02 13:00:00');

-- =============================================
-- VERIFICATION QUERIES
-- Check if all tables and data are created successfully
-- =============================================
SELECT '=== DATABASE SCHEMA CREATED SUCCESSFULLY ===' as status;

SELECT 'Tables created:' as '';
SHOW TABLES;

SELECT 'Users sample data:' as '';
SELECT email, first_name, last_name, profile_image IS NOT NULL as has_profile_image FROM users;

SELECT 'Balances sample data:' as '';
SELECT email, balance FROM balances;

SELECT 'Services available:' as '';
SELECT service_code, service_name, service_tariff, is_active FROM services ORDER BY service_name;

SELECT 'Active banners:' as '';
SELECT banner_name, banner_image FROM banners WHERE is_active = TRUE;

SELECT 'Recent transactions:' as '';
SELECT 
    invoice_number, 
    email, 
    transaction_type,
    service_name,
    total_amount,
    created_on 
FROM transactions 
ORDER BY created_on DESC 
LIMIT 5;