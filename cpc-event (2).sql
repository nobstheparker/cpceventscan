-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2025 at 08:44 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cpc-event`
--

-- --------------------------------------------------------

--
-- Table structure for table `absence_requests`
--

CREATE TABLE `absence_requests` (
  `absence_requests_id` int(11) NOT NULL,
  `id` int(11) DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `year_section` varchar(255) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `documentation` varchar(255) DEFAULT NULL,
  `submission_date` date DEFAULT NULL,
  `parent_name` varchar(255) DEFAULT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `agreement` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absence_requests`
--

INSERT INTO `absence_requests` (`absence_requests_id`, `id`, `student_id`, `full_name`, `department`, `year_section`, `reason`, `documentation`, `submission_date`, `parent_name`, `contact_info`, `agreement`, `created_at`) VALUES
(19, 52, '2022111', NULL, NULL, NULL, 'Gikalibanga', '1760523073455-18099138-event-47.png', '2025-10-15', 'Honey Balo', '0912345678', 1, '2025-10-15 10:11:13');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_controls`
--

CREATE TABLE `attendance_controls` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `morning_time_in` tinyint(1) DEFAULT 0,
  `morning_mid_event` tinyint(1) DEFAULT 0,
  `morning_time_out` tinyint(1) DEFAULT 0,
  `afternoon_time_in` tinyint(1) DEFAULT 0,
  `afternoon_mid_event` tinyint(1) DEFAULT 0,
  `afternoon_time_out` tinyint(1) DEFAULT 0,
  `feedback_form` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_controls`
--

INSERT INTO `attendance_controls` (`id`, `event_id`, `morning_time_in`, `morning_mid_event`, `morning_time_out`, `afternoon_time_in`, `afternoon_mid_event`, `afternoon_time_out`, `feedback_form`, `created_at`, `updated_at`) VALUES
(6, 52, 1, 1, 1, 1, 0, 1, 1, '2025-10-15 07:39:13', '2025-10-15 10:21:21'),
(7, 53, 1, 1, 1, 0, 0, 0, 1, '2025-10-23 11:52:46', '2025-10-23 11:58:43'),
(8, 54, 0, 0, 0, 0, 0, 0, 0, '2025-11-05 03:39:19', '2025-11-05 03:39:19'),
(9, 55, 0, 0, 0, 0, 0, 0, 0, '2025-11-05 08:04:41', '2025-11-05 08:04:41');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `course_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_code`, `course_name`, `created_at`) VALUES
(1, 'BSIT ', 'Bachelor Of Science Information Technology', '2025-07-06 09:21:47'),
(2, 'BEED', 'Bachelor of Elementary Education', '2025-07-06 09:36:28'),
(3, 'BSHM', 'Bachelor Of Science In Hospitality Management', '2025-10-15 06:39:34'),
(4, 'BSED', 'Bachelor Of Secondary Education', '2025-10-21 09:46:23');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_description` text NOT NULL,
  `start_date_time` datetime NOT NULL,
  `end_date_time` datetime NOT NULL,
  `event_location` varchar(255) NOT NULL,
  `selection_mode` enum('all','byCourse','manual') NOT NULL,
  `selected_course` varchar(50) DEFAULT NULL,
  `selected_students` text DEFAULT NULL,
  `event_program_attachment` varchar(255) DEFAULT NULL,
  `event_note` text DEFAULT NULL,
  `event_reminder` text DEFAULT NULL,
  `call_to_action_buttons_instruction` varchar(255) DEFAULT NULL,
  `volunteer_application` tinyint(1) DEFAULT 0,
  `absence_request` tinyint(1) DEFAULT 0,
  `attendance_controls` tinyint(1) DEFAULT 0,
  `custom_notification` tinyint(1) DEFAULT 0,
  `mid_event_check` tinyint(1) DEFAULT 0,
  `qr_code_option` enum('automatic','no_qr') NOT NULL,
  `qr_code_image` varchar(255) NOT NULL,
  `location_perimeter` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `event_name`, `event_description`, `start_date_time`, `end_date_time`, `event_location`, `selection_mode`, `selected_course`, `selected_students`, `event_program_attachment`, `event_note`, `event_reminder`, `call_to_action_buttons_instruction`, `volunteer_application`, `absence_request`, `attendance_controls`, `custom_notification`, `mid_event_check`, `qr_code_option`, `qr_code_image`, `location_perimeter`, `created_at`, `updated_at`, `latitude`, `longitude`) VALUES
(52, 'IT day', 'What?', '2025-10-11 23:40:00', '2025-10-12 23:37:00', 'Cordova Public College, Manuel L. Quezon National Highway, Gabi, Cogon, Cordova, Cebu, Central Visayas, 6017, Philippines', 'manual', NULL, '[\"20220773\"]', NULL, 'sdad', 'sdad', 'dsada', 1, 1, 0, 0, 0, 'automatic', '/uploads/qr/event-52.png', NULL, '2025-10-15 07:39:13', '2025-11-05 09:37:12', NULL, NULL),
(53, 'Mitin Di Avance', 'meet ', '2025-10-22 18:00:00', '2025-10-22 20:00:00', 'Cordova Public College, Manuel L. Quezon National Highway, Gabi, Cogon, Cordova, Cebu, Central Visayas, 6017, Philippines', 'all', NULL, '[]', NULL, NULL, 'Wear uniform', 'test', 1, 1, 0, 0, 0, 'automatic', '/uploads/qr/event-53.png', NULL, '2025-10-23 11:52:46', '2025-11-05 03:58:26', 10.26234270, 123.96112760),
(54, 'test1', 'test11', '2025-11-03 11:38:09', '2025-11-03 11:38:09', 'Cordova Sports Complex, Martin Francisco Street, Poblacion, Bangbang, Cordova, Cebu, Central Visayas, 6017, Philippines', 'manual', NULL, '\"[\\\"student_id = 20220773\\\",\\\"student_id = 2022111\\\"]\"', NULL, 'test', 'test', 'test', 1, 1, 0, 0, 0, 'automatic', '/uploads/qr/event-54.png', NULL, '2025-11-05 03:39:19', '2025-11-05 03:57:49', 10.25062320, 123.94975230),
(55, 'Intramurals 2025', 'Intrams', '2025-11-15 08:01:00', '2025-11-18 08:01:00', 'Cordova Sports Complex, Martin Francisco Street, Poblacion, Bangbang, Cordova, Cebu, Central Visayas, 6017, Philippines', 'manual', NULL, '\"[\\\"student_id = 20220773\\\"]\"', NULL, 'sample ', 'sample', 'sample', 1, 1, 0, 0, 0, 'automatic', '/uploads/qr/event-55.png', NULL, '2025-11-05 08:04:41', '2025-11-05 08:04:41', 10.25062320, 123.94975230);

-- --------------------------------------------------------

--
-- Table structure for table `event_attendance`
--

CREATE TABLE `event_attendance` (
  `attendance_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `time_in` datetime DEFAULT NULL,
  `trivia_time_in` datetime DEFAULT NULL,
  `time_out` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `remarks` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `absence_request` int(11) DEFAULT NULL,
  `afternoon_time_in` datetime DEFAULT NULL,
  `afternoon_trivia_time_in` datetime DEFAULT NULL,
  `afternoon_time_out` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_attendance`
--

INSERT INTO `event_attendance` (`attendance_id`, `student_id`, `id`, `time_in`, `trivia_time_in`, `time_out`, `created_at`, `updated_at`, `remarks`, `status`, `absence_request`, `afternoon_time_in`, `afternoon_trivia_time_in`, `afternoon_time_out`) VALUES
(32, 2022111, 52, '2025-10-07 16:33:42', NULL, NULL, '2025-10-15 07:44:50', '2025-10-21 16:17:05', '', 0, NULL, '2025-10-15 17:20:21', '2025-10-08 17:20:25', '2025-10-15 16:51:58'),
(33, 2022111, 53, '2025-10-23 20:11:18', '2025-10-23 20:17:38', '2025-10-23 20:22:17', '2025-10-23 12:11:18', '2025-10-23 12:22:17', '', 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `event_trivia`
--

CREATE TABLE `event_trivia` (
  `trivia_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `time_period` enum('morning','afternoon') NOT NULL,
  `question` varchar(255) NOT NULL,
  `option1` varchar(255) NOT NULL,
  `option2` varchar(255) NOT NULL,
  `correct_answer` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_trivia`
--

INSERT INTO `event_trivia` (`trivia_id`, `event_id`, `time_period`, `question`, `option1`, `option2`, `correct_answer`, `created_at`) VALUES
(9, 52, 'morning', 'what is ', 'haha', 'hehe', 'hehe', '2025-10-15 07:46:18'),
(10, 53, 'morning', 'What are the two partylist?', 'BLISS PARTYLIST & TAPAT PARTYLIST', 'SIGMUND FRUED & GC KA SOHO', 'BLISS PARTYLIST & TAPAT PARTYLIST', '2025-10-23 12:02:54');

-- --------------------------------------------------------

--
-- Table structure for table `face_images`
--

CREATE TABLE `face_images` (
  `id` int(11) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `image` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `luxand_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `face_images`
--

INSERT INTO `face_images` (`id`, `student_id`, `image`, `created_at`, `luxand_id`) VALUES
(18, '20241234567', '[-0.15517555177211761,0.12426842004060745,0.05837724730372429,-0.008525809273123741,-0.015617720782756805,0.002710001775994897,0.00637982040643692,-0.0994134172797203,0.15455587208271027,-0.003385291201993823,0.31888920068740845,-0.09248289465904236,-0.20', '2025-10-08 06:49:21', NULL),
(28, '2024123456', '2024123456.jpg', '2025-10-14 08:52:31', '1a3d6e9e-a8db-11f0-86d3-0242ac120002'),
(29, '202412345', '202412345.jpg', '2025-10-14 09:58:21', '4ca09ddc-a8e4-11f0-86d3-0242ac120002'),
(30, '2022111', '2022111.jpg', '2025-10-15 07:16:43', 'e642ca79-a996-11f0-86d3-0242ac120002');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `notes` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `student_id`, `id`, `notes`, `created_at`) VALUES
(35, 2022111, 52, 'it was okay', '2025-10-15 07:47:59'),
(36, 2022111, 53, 'nice event', '2025-10-23 12:49:58');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `notif_type` varchar(100) NOT NULL,
  `notif_message` text NOT NULL,
  `recipient_mode` enum('all','byCourse','manual') DEFAULT 'all',
  `selected_courses` text DEFAULT NULL,
  `selected_students` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `notif_type`, `notif_message`, `recipient_mode`, `selected_courses`, `selected_students`, `created_at`, `updated_at`) VALUES
(4, 'Test', 'Test Notification', 'byCourse', '[2]', '[]', '2025-10-07 16:24:40', '2025-10-07 18:43:22'),
(5, 'Cordova Test', 'This is only a test notification', 'all', '[]', '[]', '2025-10-06 19:06:32', '2025-10-07 19:11:04'),
(7, 'Notification Sample', 'Notification Sample', 'byCourse', '[1]', '[]', '2025-10-08 06:34:59', '2025-10-08 07:05:28');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `section_id` int(11) NOT NULL,
  `section_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`section_id`, `section_name`) VALUES
(3, 'B');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `student_id` varchar(50) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `sex` enum('Male','Female','Other') NOT NULL,
  `age` int(11) DEFAULT NULL,
  `course_id` int(50) NOT NULL,
  `year_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `auth` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_id`, `last_name`, `first_name`, `middle_name`, `birthday`, `sex`, `age`, `course_id`, `year_id`, `section_id`, `phone`, `status`, `email`, `password`, `auth`, `address`, `created_at`) VALUES
(22, '20220773', 'Almojallas', 'Honey Margarette', 'Paragoso', '2004-03-30', 'Female', 0, 1, 6, 3, '', 0, 'margarettealison.paragoso@gmail.com', '$2b$10$qCICElXDDLPsjJ9pHPZqvuTY12zHJSRPIuOyuHwAFmW743n/ahOJW', 0, '', '2025-10-15 06:38:12'),
(23, '2022111', 'Dumayao', 'Novie', 'Imba', '2025-10-15', 'Female', 0, 1, 1, 1, '', 0, 'noviecyledumayao@gnail.com', '$2b$10$0j9yVehnpoxhv0y7Li6a9.GIfVmOPiFN0K7gzIXPEQTkT.uvK9Qce', 0, '', '2025-10-15 07:13:28');

-- --------------------------------------------------------

--
-- Table structure for table `student_notifications`
--

CREATE TABLE `student_notifications` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `mark_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_notifications`
--

INSERT INTO `student_notifications` (`id`, `student_id`, `notification_id`, `mark_read`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 1, '2025-10-07 17:36:25', '2025-10-07 17:36:25'),
(2, 18, 4, 1, '2025-10-07 18:42:38', '2025-10-07 18:42:38'),
(3, 4, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(4, 14, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(5, 5, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(6, 15, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(7, 11, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(8, 13, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(9, 9, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(10, 10, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(11, 16, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(12, 12, 5, 0, '2025-10-07 19:06:32', '2025-10-07 19:06:32'),
(13, 18, 5, 1, '2025-10-07 19:06:32', '2025-10-08 04:21:07'),
(25, 18, 7, 1, '2025-10-08 06:35:46', '2025-10-08 06:35:46'),
(38, 20, 7, 1, '2025-10-11 06:57:30', '2025-10-11 06:57:30'),
(40, 20, 5, 1, '2025-10-11 06:57:34', '2025-10-11 06:57:34'),
(79, 22, 7, 1, '2025-10-15 07:59:37', '2025-10-15 07:59:37'),
(80, 22, 5, 1, '2025-10-15 07:59:42', '2025-10-15 07:59:42');

-- --------------------------------------------------------

--
-- Table structure for table `student_request`
--

CREATE TABLE `student_request` (
  `request_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `volunteered_id` int(11) DEFAULT NULL,
  `absence_requests_id` int(11) DEFAULT NULL,
  `date_requested` datetime NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_request`
--

INSERT INTO `student_request` (`request_id`, `student_id`, `volunteered_id`, `absence_requests_id`, `date_requested`, `status`, `id`) VALUES
(12, 20220773, 19, NULL, '2025-10-15 14:50:03', 1, 51),
(13, 2022111, 20, NULL, '2025-10-15 15:41:15', 1, 52),
(14, 2022111, NULL, 19, '2025-10-15 18:11:13', 2, 52);

-- --------------------------------------------------------

--
-- Table structure for table `two_factor`
--

CREATE TABLE `two_factor` (
  `twofa_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT 0 COMMENT '0 = enabled, 1 = disabled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `two_factor`
--

INSERT INTO `two_factor` (`twofa_id`, `student_id`, `status`) VALUES
(1, 202412345, 0),
(2, 200332323, 1),
(3, 202312323, 1),
(4, 2024123456, 0),
(5, 202512345, 0),
(6, 20220773, 0),
(7, 2022111, 0);

-- --------------------------------------------------------

--
-- Table structure for table `two_factor_codes`
--

CREATE TABLE `two_factor_codes` (
  `id` int(11) NOT NULL,
  `student_id` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `two_factor_codes`
--

INSERT INTO `two_factor_codes` (`id`, `student_id`, `code`, `expires_at`) VALUES
(18, '202412345', '183966', '2025-10-07 15:35:35'),
(19, '202412345', '533897', '2025-10-07 15:37:12'),
(20, '202412345', '239498', '2025-10-07 15:40:48'),
(21, '202412345', '431285', '2025-10-07 15:40:51'),
(22, '202412345', '939378', '2025-10-07 15:45:27'),
(24, '202412345', '879373', '2025-10-07 15:48:21'),
(25, '202412345', '553629', '2025-10-07 15:49:24'),
(26, '202412345', '777787', '2025-10-07 15:50:03'),
(28, '202412345', '191070', '2025-10-07 15:51:24'),
(29, '202412345', '496292', '2025-10-07 16:29:37'),
(30, '202412345', '484857', '2025-10-07 17:13:11'),
(31, '202412345', '769432', '2025-10-07 17:13:25'),
(32, '2024123456', '633437', '2025-10-07 20:03:48'),
(33, '2024123456', '328584', '2025-10-07 20:03:52'),
(34, '2024123456', '303826', '2025-10-07 20:04:12'),
(35, '2024123456', '848163', '2025-10-07 20:04:53'),
(36, '202412345', '986589', '2025-10-07 21:49:26'),
(37, '202412345', '325306', '2025-10-08 01:24:55'),
(38, '202412345', '214477', '2025-10-08 02:59:12'),
(39, '2024123456', '341841', '2025-10-08 14:37:43'),
(41, '202412345', '154611', '2025-10-11 04:04:18'),
(42, '202412345', '956848', '2025-10-11 04:04:20'),
(43, '202412345', '580830', '2025-10-14 17:59:47'),
(45, '20220773', '203328', '2025-10-15 15:13:52'),
(46, '20220773', '906811', '2025-10-15 15:13:54');

-- --------------------------------------------------------

--
-- Table structure for table `updates`
--

CREATE TABLE `updates` (
  `update_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Inactive',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `updates`
--

INSERT INTO `updates` (`update_id`, `name`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 'test', 'This is a test', 'Active', '2025-10-10 12:58:03', '2025-10-11 09:12:50');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `f_name` varchar(255) NOT NULL,
  `m_name` varchar(255) NOT NULL,
  `l_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `f_name`, `m_name`, `l_name`, `email`, `password`, `role`, `status`) VALUES
(2, 'Super', 'Admin', '', 'superadmin@gmail.com', '$2b$10$tiRu/xL7OIgmUmw2JMGMkuiZvcQPme72QDg4gQeO7t8/EOXv2edya', 0, 0),
(6, 'Admin', '', '', 'admin1@gmail.com', '$2b$10$/olRZ10Rn6NVVOIMBcvq1OAcXMpmDbWxGYy0xwscjX5f3zrvqrFr6', 0, 2),
(8, 'admintwo', '', '', 'admintwo@gmail.com', '$2b$10$fLJjWzkiUbI/EYURP9Rn2Oo/WBNC43yxkB7.kNY9KjTsBI/kklLym', 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `volunteers`
--

CREATE TABLE `volunteers` (
  `volunteered_id` int(11) NOT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `role` varchar(100) NOT NULL,
  `motivation` varchar(100) NOT NULL,
  `motivation_other` text DEFAULT NULL,
  `volunteered_before` enum('Yes','No') NOT NULL,
  `past_role` text DEFAULT NULL,
  `skills` varchar(100) NOT NULL,
  `skills_other` text DEFAULT NULL,
  `available` enum('Yes','No') NOT NULL,
  `team_preference` varchar(50) NOT NULL,
  `team_other` text DEFAULT NULL,
  `agreement` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `id` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volunteers`
--

INSERT INTO `volunteers` (`volunteered_id`, `student_id`, `role`, `motivation`, `motivation_other`, `volunteered_before`, `past_role`, `skills`, `skills_other`, `available`, `team_preference`, `team_other`, `agreement`, `created_at`, `id`, `status`) VALUES
(19, '20220773', 'tech', 'Community involvement', '', 'No', '', 'Teamwork', '', 'Yes', 'Collaborator', '', 1, '2025-10-15 06:50:03', 51, 0),
(20, '2022111', 'tech', 'Gaining experience', '', 'No', '', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-15 07:41:15', 52, 0);

-- --------------------------------------------------------

--
-- Table structure for table `year_levels`
--

CREATE TABLE `year_levels` (
  `year_id` int(11) NOT NULL,
  `year_level` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `year_levels`
--

INSERT INTO `year_levels` (`year_id`, `year_level`) VALUES
(6, '3');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absence_requests`
--
ALTER TABLE `absence_requests`
  ADD PRIMARY KEY (`absence_requests_id`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `attendance_controls`
--
ALTER TABLE `attendance_controls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `event_attendance`
--
ALTER TABLE `event_attendance`
  ADD PRIMARY KEY (`attendance_id`);

--
-- Indexes for table `event_trivia`
--
ALTER TABLE `event_trivia`
  ADD PRIMARY KEY (`trivia_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `face_images`
--
ALTER TABLE `face_images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`section_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `student_notifications`
--
ALTER TABLE `student_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notification_id` (`notification_id`);

--
-- Indexes for table `student_request`
--
ALTER TABLE `student_request`
  ADD PRIMARY KEY (`request_id`);

--
-- Indexes for table `two_factor`
--
ALTER TABLE `two_factor`
  ADD PRIMARY KEY (`twofa_id`);

--
-- Indexes for table `two_factor_codes`
--
ALTER TABLE `two_factor_codes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `updates`
--
ALTER TABLE `updates`
  ADD PRIMARY KEY (`update_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `volunteers`
--
ALTER TABLE `volunteers`
  ADD PRIMARY KEY (`volunteered_id`);

--
-- Indexes for table `year_levels`
--
ALTER TABLE `year_levels`
  ADD PRIMARY KEY (`year_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absence_requests`
--
ALTER TABLE `absence_requests`
  MODIFY `absence_requests_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `attendance_controls`
--
ALTER TABLE `attendance_controls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `event_attendance`
--
ALTER TABLE `event_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `event_trivia`
--
ALTER TABLE `event_trivia`
  MODIFY `trivia_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `face_images`
--
ALTER TABLE `face_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `student_notifications`
--
ALTER TABLE `student_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `student_request`
--
ALTER TABLE `student_request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `two_factor`
--
ALTER TABLE `two_factor`
  MODIFY `twofa_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `two_factor_codes`
--
ALTER TABLE `two_factor_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `updates`
--
ALTER TABLE `updates`
  MODIFY `update_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `volunteers`
--
ALTER TABLE `volunteers`
  MODIFY `volunteered_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `year_levels`
--
ALTER TABLE `year_levels`
  MODIFY `year_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absence_requests`
--
ALTER TABLE `absence_requests`
  ADD CONSTRAINT `absence_requests_ibfk_1` FOREIGN KEY (`id`) REFERENCES `events` (`id`);

--
-- Constraints for table `attendance_controls`
--
ALTER TABLE `attendance_controls`
  ADD CONSTRAINT `attendance_controls_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `event_trivia`
--
ALTER TABLE `event_trivia`
  ADD CONSTRAINT `event_trivia_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_notifications`
--
ALTER TABLE `student_notifications`
  ADD CONSTRAINT `student_notifications_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
