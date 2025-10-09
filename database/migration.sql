-- database/migration.sql
-- Migration script for existing databases
-- Use this if upgrading from previous version

USE nutech_db;

-- =============================================
-- MIGRATION: Convert DECIMAL to INT
-- =============================================

-- Migrate balances table from DECIMAL to INT
ALTER TABLE balances MODIFY COLUMN balance INT DEFAULT 0;
UPDATE balances SET balance = ROUND(balance) WHERE balance IS NOT NULL;

-- Migrate services table tariff from DECIMAL to INT  
ALTER TABLE services MODIFY COLUMN service_tariff INT NOT NULL;
UPDATE services SET service_tariff = ROUND(service_tariff) WHERE service_tariff IS NOT NULL;

-- =============================================
-- MIGRATION: Update transactions for TOPUP
-- =============================================

-- Remove UNIQUE constraint from invoice_number if exists
SET @dbname = DATABASE();
SET @tablename = "transactions";
SET @indexname = "idx_invoice_number";

-- Check if unique index exists
SET @sql = CONCAT(
    'SELECT COUNT(*) INTO @index_exists ',
    'FROM INFORMATION_SCHEMA.STATISTICS ',
    'WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND INDEX_NAME = ? AND NON_UNIQUE = 0'
);

PREPARE stmt FROM @sql;
EXECUTE stmt USING @dbname, @tablename, @indexname;
DEALLOCATE PREPARE stmt;

-- Drop unique index if exists
SET @drop_sql = IF(
    @index_exists > 0,
    CONCAT('ALTER TABLE ', @tablename, ' DROP INDEX ', @indexname),
    'SELECT "Unique index does not exist, skipping..." as status'
);

PREPARE drop_stmt FROM @drop_sql;
EXECUTE drop_stmt;
DEALLOCATE PREPARE drop_stmt;

-- Modify invoice_number to allow NULL
ALTER TABLE transactions MODIFY COLUMN invoice_number VARCHAR(50) NULL;

-- Recreate index as non-unique
CREATE INDEX idx_invoice_number ON transactions(invoice_number);

-- Update existing TOPUP transactions to have NULL invoice_number
UPDATE transactions 
SET invoice_number = NULL 
WHERE transaction_type = 'TOPUP' AND invoice_number IS NOT NULL;

-- =============================================
-- MIGRATION VERIFICATION
-- =============================================
SELECT '=== MIGRATION COMPLETED SUCCESSFULLY ===' as status;

SELECT 'Balances migrated to INT:' as '';
SELECT email, balance FROM balances LIMIT 3;

SELECT 'Services tariffs migrated to INT:' as '';
SELECT service_code, service_name, service_tariff FROM services LIMIT 3;

SELECT 'TOPUP transactions with NULL invoice_number:' as '';
SELECT COUNT(*) as topup_count 
FROM transactions 
WHERE transaction_type = 'TOPUP' AND invoice_number IS NULL;

SELECT 'Total transactions by type:' as '';
SELECT transaction_type, COUNT(*) as count 
FROM transactions 
GROUP BY transaction_type;