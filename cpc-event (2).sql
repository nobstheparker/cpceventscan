-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 11, 2025 at 06:10 AM
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
(15, 48, '2024123456', NULL, NULL, NULL, 'test', '1760085012741-874556446-FireShot Capture 006 - prototype â Figma - [www.figma.com].png', '2025-10-10', 'test', '0932322', 1, '2025-10-10 08:30:12');

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
(2, 48, 1, 0, 0, 1, 0, 0, 0, '2025-10-10 08:07:09', '2025-10-10 20:58:51');

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
(2, 'BEED', 'Bachelor of Elementary Education', '2025-07-06 09:36:28');

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
(48, 'CPC Day 1', 'CPC Day 1', '2025-10-09 16:05:57', '2025-10-10 15:59:00', 'Cordova Sports Complex, Martin Francisco Street, Poblacion, Bangbang, Cordova, Cebu, Central Visayas, 6017, Philippines', 'all', NULL, '[]', 'uploads/events/event-program-48.png', 'test', 'test', 'test', 1, 0, 0, 0, 0, 'automatic', '/uploads/qr/event-48.png', NULL, '2025-10-10 08:07:09', '2025-10-11 03:31:40', 10.25062320, 123.94975230);

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
(15, 202412345, 43, '2025-09-30 20:34:49', NULL, '2025-09-30 20:44:37', '2025-09-30 12:34:49', '2025-10-02 10:13:57', '', 1, NULL, NULL, NULL, NULL),
(16, 2024123456, 43, '2025-10-08 22:44:07', '2025-10-09 20:20:41', '2025-10-09 20:06:19', '2025-10-02 06:53:17', '2025-10-09 12:25:29', '', 0, NULL, '2025-10-09 20:11:26', '2025-10-09 20:25:29', '2025-10-09 20:18:23'),
(22, 2024123456, 44, '2025-10-02 15:38:12', '2025-10-03 16:07:09', NULL, '2025-10-02 07:11:12', '2025-10-03 08:07:43', '', 1, NULL, NULL, NULL, NULL),
(24, 2024123456, 48, '2025-10-10 23:52:19', NULL, NULL, '2025-10-10 15:51:59', '2025-10-10 21:01:09', '', 0, NULL, '2025-10-11 05:01:09', NULL, NULL);

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
(15, '202412345', '[-0.13934126496315002,0.1642361730337143,0.06822387129068375,-0.0028064565267413855,-0.03319314122200012,0.032561808824539185,-0.045776307582855225,-0.05129064992070198,0.16079117357730865,-0.08042806386947632,0.3265182077884674,-0.02173396572470665,-0.21', '2025-09-24 06:46:22', NULL),
(18, '20241234567', '[-0.15517555177211761,0.12426842004060745,0.05837724730372429,-0.008525809273123741,-0.015617720782756805,0.002710001775994897,0.00637982040643692,-0.0994134172797203,0.15455587208271027,-0.003385291201993823,0.31888920068740845,-0.09248289465904236,-0.20', '2025-10-08 06:49:21', NULL),
(24, '2024123456', '2024123456.jpg', '2025-10-09 05:59:07', '0f80f8f6-a4d5-11f0-86d3-0242ac120002');

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
(27, 2024123456, 48, 'The event is pangit', '2025-10-10 10:56:30');

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
(6, 'testing', 'testing ni', 'all', '[]', '[]', '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(7, 'Notification Sample', 'Notification Sample', 'byCourse', '[1]', '[]', '2025-10-08 06:34:59', '2025-10-08 07:05:28'),
(8, 'test', 'test', 'all', '[]', '[]', '2025-10-10 14:33:34', '2025-10-10 14:33:34');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `section_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `year_id` int(11) NOT NULL,
  `section_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`section_id`, `course_id`, `year_id`, `section_name`) VALUES
(1, 2, 1, 'D');

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
(4, '232323', 'Balo', 'Honey', 'Almojallas', '1997-05-03', 'Female', 21, 0, 1, 0, '', 0, 'almojallas@gmail.com', '12345', 0, '', '2025-07-06 04:59:05'),
(5, '23213', 'dsad', 'asdsad', 'asdas', '2025-07-02', 'Female', 23, 0, 2, 0, '', 0, 'dasd@gmail.com', '123213213', 0, '', '2025-07-06 04:59:53'),
(9, '202512345', 'Almojallas', 'Honey', 'Paragoso', '2025-07-06', 'Male', 21, 0, 1, 0, '', 0, 'margarettealison.paragoso@gmail.com', '$2b$10$w3tIM2Tlxg/eu7vJI.VwiOzjuIRNiduz.PPWLyNIWCK/oOyM39zg6', 0, '', '2025-07-06 05:36:47'),
(10, '200332323', 'Dumayao', 'Novie', 'Balo', '2025-07-10', 'Female', 21, 0, 1, 0, '', 0, 'noviecyledumayao2003@gmail.com', '$2b$10$AERI3Q9FoDBIlOXZ364OEOVjqoDg.Hn4qWT1vBDKC8laA41h0LeU2', 0, '', '2025-07-10 08:47:01'),
(11, '202312323', 'Delgado', 'Kaye', 'Balo', '2025-07-10', 'Female', 23, 0, 1, 0, '', 1, 'lepasanakaye@gmail.com', '$2b$10$qEJ/p0rF2t2GeFjvHPZ0weHQrU/z5WIytBiICU/mGOulVurYtQmIi', 0, '', '2025-07-10 08:54:23'),
(12, '23232', 'sdsad', 'sdsad', 'sdsad', '2025-07-24', '', 0, 1, 2, 1, '', 0, 'rodel123@gmail.com', '$2b$10$jBJzAGXWLziAKPVHwstQ0eHVQ/.92TEgI6BB8KHMEDqxScbsljmZK', 0, '', '2025-07-24 12:27:24'),
(13, '321321', 'dsds', 'dsadsa', 'dsadsad', '2025-07-23', 'Female', 23, 1, 1, 1, '', 0, 'lll@gmail.com', '$2b$10$qKLbZDJ5a.BQmTUkJfuKees9xTmVGsGxICbhubzXaMNnoxmSBdnym', 0, '', '2025-07-24 12:43:58'),
(14, '232', 'asdsad', 'sadsd', 'sadsada', '2025-07-21', 'Female', 21, 1, 1, 1, '', 0, 'asdsad@gmail.com', '$2b$10$SDHdhHqwiBZSiKGksoAboe7LKVImQaKzybWNl3KpvrWB75vS6mwha', 0, '', '2025-07-28 04:45:00'),
(15, '2323', 'asd', 'adasd', 'adsad', '2025-07-28', 'Female', 21, 1, 1, 1, '', 0, 'dasdas@gmail.com', '$2b$10$5CaWsYtzktC5ZAq8kfGhj.vW9A8U6roC2lAxKVjHMGzHWJmY7u1YK', 0, '', '2025-07-28 06:24:39'),
(16, '202412345', 'Ompad', 'Rodel', 'Pacaldo', '2024-01-03', 'Male', 21, 1, 2, 1, '09123456789', 0, 'ompadrodel03@gmail.com', '$2b$10$5FWysZGYPVyC1agQ.O3T1u5lho50xdh6cNTB8oz3BRmCxZztfZp1a', 1, 'camolinas cordova cebu', '2025-07-28 07:27:21'),
(18, '2024123456', 'Celades', 'Lovely Jean', 'Garcia', '2025-09-30', 'Female', 23, 2, 1, 1, '', 0, 'rodel@wpcrank.com', '$2b$10$Do4293zbDh3eA3Qpjh7xZeupNv4oK8EzGpjJjXSykVfct5Us6Yb0C', 1, '', '2025-10-02 06:41:50'),
(19, '20241234567', 'testing', 'testing', 'testing', '2025-10-17', 'Male', 23, 1, 1, 1, '', 0, 'test@gmail.com', '$2b$10$2fYCmt4/Py3t9j3sOT2ejO6zYE35uHTT9I9cd5KXQnigSrJZCCz4.', 0, '', '2025-10-08 06:46:09');

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
(14, 4, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(15, 5, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(16, 9, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(17, 10, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(18, 11, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(19, 12, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(20, 13, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(21, 14, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(22, 15, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(23, 16, 6, 0, '2025-10-07 19:09:34', '2025-10-07 19:09:34'),
(24, 18, 6, 1, '2025-10-07 19:09:34', '2025-10-08 04:21:03'),
(25, 18, 7, 1, '2025-10-08 06:35:46', '2025-10-08 06:35:46'),
(26, 4, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(27, 14, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(28, 5, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(29, 15, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(30, 11, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(31, 13, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(32, 9, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(33, 10, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(34, 16, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(35, 12, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(36, 18, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34'),
(37, 19, 8, 0, '2025-10-10 14:33:34', '2025-10-10 14:33:34');

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
(1, 202412345, 12, NULL, '2025-10-01 16:45:20', 2, 43),
(2, 202412345, NULL, 13, '2025-10-01 16:54:21', 1, 43),
(6, 2024123456, 17, NULL, '2025-10-07 21:27:24', 2, 47),
(7, 2024123456, 18, NULL, '2025-10-10 16:17:44', 1, 48),
(8, 2024123456, NULL, 15, '2025-10-10 16:30:12', 1, 48);

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
(1, 202412345, 1),
(2, 200332323, 1),
(3, 202312323, 1),
(4, 2024123456, 0),
(5, 202512345, 0);

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
(42, '202412345', '956848', '2025-10-11 04:04:20');

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
(1, 'test', 'This is a test', 'Inactive', '2025-10-10 12:58:03', '2025-10-10 12:58:03'),
(2, 'test', 'This is a test sample', 'Inactive', '2025-10-10 13:01:54', '2025-10-10 13:54:19');

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
(1, 'Honey Margs', '', 'Almojallas', 'honey123@gmail.com', '12345', 1, 0),
(2, 'rodelya', 'gwapo', '', 'rodel@wpcrank.com', '$2b$10$VVKvD4iC9aFSGi4xfSOjO.GTscSajNULe46bFot3LcLJKjMD95XUO', 0, 2),
(3, 'Lovely', '', '', 'lovely123@gmail.com', '$2b$10$/KqnODovmGcDr3OD9uhwIO.BKMcvnlV76vARLhYWJYq2h/hQZl/I6', 0, 1),
(4, 'delz', '', '', 'delz@gmail.com', '$2b$10$OT9R7aPfCnFKeq3/MNkPqu6lzu6GxHm1nWYxnrq5BZyFKRVw/Mffq', 0, 0);

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
(18, '2024123456', 'option1', 'Gaining experience', '', 'Yes', 'test', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-10 08:17:44', 48, 0);

-- --------------------------------------------------------

--
-- Table structure for table `year_levels`
--

CREATE TABLE `year_levels` (
  `year_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `year_level` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `year_levels`
--

INSERT INTO `year_levels` (`year_id`, `course_id`, `year_level`) VALUES
(1, 1, '3rd'),
(2, 2, '2nd'),
(3, 2, '2nd');

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
  ADD PRIMARY KEY (`section_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `year_id` (`year_id`);

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
  ADD PRIMARY KEY (`year_id`),
  ADD KEY `course_id` (`course_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absence_requests`
--
ALTER TABLE `absence_requests`
  MODIFY `absence_requests_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `attendance_controls`
--
ALTER TABLE `attendance_controls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `event_attendance`
--
ALTER TABLE `event_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `face_images`
--
ALTER TABLE `face_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `student_notifications`
--
ALTER TABLE `student_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `student_request`
--
ALTER TABLE `student_request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `two_factor`
--
ALTER TABLE `two_factor`
  MODIFY `twofa_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `two_factor_codes`
--
ALTER TABLE `two_factor_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `updates`
--
ALTER TABLE `updates`
  MODIFY `update_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `volunteers`
--
ALTER TABLE `volunteers`
  MODIFY `volunteered_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `year_levels`
--
ALTER TABLE `year_levels`
  MODIFY `year_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sections_ibfk_2` FOREIGN KEY (`year_id`) REFERENCES `year_levels` (`year_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_notifications`
--
ALTER TABLE `student_notifications`
  ADD CONSTRAINT `student_notifications_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `year_levels`
--
ALTER TABLE `year_levels`
  ADD CONSTRAINT `year_levels_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
