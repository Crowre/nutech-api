-- Create database
CREATE DATABASE IF NOT EXISTS nutech_db;
USE nutech_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_image TEXT,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from users;
-- Balances table
CREATE TABLE IF NOT EXISTS balances (
    email VARCHAR(255) PRIMARY KEY,
    balance DECIMAL(15,2) DEFAULT 0,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
);
ALTER TABLE balances MODIFY COLUMN balance INT DEFAULT 0;
select * from balances;
-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    service_code VARCHAR(50),
    service_name VARCHAR(255),
    transaction_type ENUM('TOPUP', 'PAYMENT') NOT NULL,
    total_amount INT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
);
ALTER TABLE transactions MODIFY COLUMN invoice_number VARCHAR(50) NULL;

select * from transactions;
DROP TABLE transactions;
-- Banners
CREATE TABLE banners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    banner_name VARCHAR(255) NOT NULL,
    banner_image VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO banners (banner_name, banner_image, description) VALUES
('Banner 1', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet'),
('Banner 2', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet'),
('Banner 3', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet'),
('Banner 4', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet'),
('Banner 5', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet'),
('Banner 6', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet');

-- Buat tabel services
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    service_code VARCHAR(50) UNIQUE NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    service_icon VARCHAR(500) NOT NULL,
    service_tariff INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from services;
DESCRIBE services;
ALTER TABLE services MODIFY COLUMN service_tariff INT NOT NULL;
-- Insert sample data
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

-- Create index for better performance
CREATE INDEX idx_transactions_email ON transactions(email);
CREATE INDEX idx_transactions_created_on ON transactions(created_on);