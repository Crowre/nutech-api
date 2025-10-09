-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 09, 2025 at 08:49 AM
-- Server version: 10.4.28-MariaDB-log
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nutech_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `balances`
--

CREATE TABLE `balances` (
  `email` varchar(255) NOT NULL,
  `balance` int(11) DEFAULT 0,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `balances`
--

INSERT INTO `balances` (`email`, `balance`, `created_on`, `updated_on`) VALUES
('satria123@gmail.com', 3520000, '2025-10-09 04:10:25', '2025-10-09 05:28:42'),
('wanda123@gmail.com', 1400000, '2025-10-08 03:27:15', '2025-10-09 02:12:56'),
('wildan123', 0, '2025-10-08 03:15:15', '2025-10-08 03:15:15'),
('wildan123@gmail.com', 0, '2025-10-08 02:31:00', '2025-10-08 03:09:55');

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

CREATE TABLE `banners` (
  `id` int(11) NOT NULL,
  `banner_name` varchar(255) NOT NULL,
  `banner_image` varchar(500) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banners`
--

INSERT INTO `banners` (`id`, `banner_name`, `banner_image`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Banner 1', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53'),
(2, 'Banner 2', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53'),
(3, 'Banner 3', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53'),
(4, 'Banner 4', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53'),
(5, 'Banner 5', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53'),
(6, 'Banner 6', 'https://www.zica.co.zm/wp-content/uploads/2021/02/dummy-profile-image.png', 'Lerem Ipsum Dolor sit amet', 1, '2025-10-08 07:28:53', '2025-10-08 07:28:53');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `service_code` varchar(50) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `service_icon` varchar(500) NOT NULL,
  `service_tariff` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `service_code`, `service_name`, `service_icon`, `service_tariff`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'PAJAK', 'Pajak PBB', 'https://nutech-integrasi.app/dummy.jpg', 40000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(2, 'PLN', 'Listrik', 'https://nutech-integrasi.app/dummy.jpg', 10000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(3, 'PDAM', 'PDAM Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 40000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(4, 'PULSA', 'Pulsa', 'https://nutech-integrasi.app/dummy.jpg', 40000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(5, 'PGN', 'PGN Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(6, 'MUSIK', 'Musik Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(7, 'TV', 'TV Berlangganan', 'https://nutech-integrasi.app/dummy.jpg', 50000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(8, 'PAKET_DATA', 'Paket data', 'https://nutech-integrasi.app/dummy.jpg', 50000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(9, 'VOUCHER_GAME', 'Voucher Game', 'https://nutech-integrasi.app/dummy.jpg', 100000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(10, 'VOUCHER_MAKANAN', 'Voucher Makanan', 'https://nutech-integrasi.app/dummy.jpg', 100000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(11, 'QURBAN', 'Qurban', 'https://nutech-integrasi.app/dummy.jpg', 200000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19'),
(12, 'ZAKAT', 'Zakat', 'https://nutech-integrasi.app/dummy.jpg', 300000, 1, '2025-10-08 08:18:19', '2025-10-08 08:18:19');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `service_code` varchar(50) DEFAULT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `transaction_type` enum('TOPUP','PAYMENT') NOT NULL,
  `total_amount` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `invoice_number`, `email`, `service_code`, `service_name`, `transaction_type`, `total_amount`, `created_on`) VALUES
(1, '', 'wanda123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 1000000, '2025-10-09 01:25:21'),
(2, 'INV-1759973316490-6672', 'wanda123@gmail.com', 'PLN', 'Listrik', 'PAYMENT', 10000, '2025-10-09 01:28:36'),
(3, 'INV-1759975919596-1252', 'wanda123@gmail.com', 'PULSA', 'Pulsa', 'PAYMENT', 40000, '2025-10-09 02:11:59'),
(4, 'INV-1759975943000-7557', 'wanda123@gmail.com', 'QURBAN', 'Qurban', 'PAYMENT', 200000, '2025-10-09 02:12:23'),
(5, 'INV-1759975958087-5980', 'wanda123@gmail.com', 'TV', 'TV Berlangganan', 'PAYMENT', 50000, '2025-10-09 02:12:38'),
(6, 'INV-1759975976598-8633', 'wanda123@gmail.com', 'ZAKAT', 'Zakat', 'PAYMENT', 300000, '2025-10-09 02:12:56'),
(10, NULL, 'satria123@gmail.com', 'TOPUP', 'Top Up Balance', 'TOPUP', 4000000, '2025-10-09 05:23:04'),
(11, 'INV-1759987657035-8936', 'satria123@gmail.com', 'ZAKAT', 'Zakat', 'PAYMENT', 300000, '2025-10-09 05:27:37'),
(12, 'INV-1759987689241-3933', 'satria123@gmail.com', 'MUSIK', 'Musik Berlangganan', 'PAYMENT', 50000, '2025-10-09 05:28:09'),
(13, 'INV-1759987701565-4683', 'satria123@gmail.com', 'PAKET_DATA', 'Paket data', 'PAYMENT', 50000, '2025-10-09 05:28:21'),
(14, 'INV-1759987712092-3059', 'satria123@gmail.com', 'PAJAK', 'Pajak PBB', 'PAYMENT', 40000, '2025-10-09 05:28:32'),
(15, 'INV-1759987722844-4375', 'satria123@gmail.com', 'PDAM', 'PDAM Berlangganan', 'PAYMENT', 40000, '2025-10-09 05:28:42');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `profile_image` text DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`email`, `password`, `first_name`, `last_name`, `profile_image`, `created_on`, `updated_on`) VALUES
('satria123@gmail.com', '$2b$10$QEArPOV4t1ZUu85nwCf53e7zMU8hCrHs63cWNbgD0xoAD8OU.Hbse', 'satria adhiyasta', 'utama', 'http://localhost:3000/profile-images/profile-1759983982909-863783377.jpg', '2025-10-09 04:10:25', '2025-10-09 04:26:22'),
('wanda123@gmail.com', '$2b$10$XXpHfmQJeHhF7YEHvnnze.V4UsoNgLL4Qc5ZZj7j1hma./ubrJ2iu', 'wanda ayu', 'hanifah', 'http://localhost:3000/profile-images/profile-1759907145726-587214446.jpg', '2025-10-08 03:27:15', '2025-10-08 07:05:45'),
('wildan123', '$2b$10$8rdinSZDVuvD38cW9Hb8MOiK31JiaPNHcUWztyUIDpKBMyytPE1Du', 'wildan', 'utama', NULL, '2025-10-08 03:15:15', '2025-10-08 03:15:15'),
('wildan123@gmail.com', '$2b$10$.DclupMOsN9tQdnQzDICSuL0RviTu4ztgbCpduFnqgl3Ona6G5qom', 'wanda ayu', 'utama', NULL, '2025-10-08 02:31:00', '2025-10-08 04:34:38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `balances`
--
ALTER TABLE `balances`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `service_code` (`service_code`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `balances`
--
ALTER TABLE `balances`
  ADD CONSTRAINT `balances_ibfk_1` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
