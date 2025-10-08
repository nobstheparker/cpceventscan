-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 04, 2025 at 06:44 AM
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
(11, 43, '202412345', 'test', 'option1', 'option2', 'This is a sample test', '1759237679609-158512463-event-12.png', '2025-09-10', 'rodel', '09123456', 1, '2025-09-30 13:07:59'),
(12, 43, '202412345', 'Rodel', 'option1', 'option1', 'test', '1759308654987-804796994-FireShot Capture 003 - prototype â Figma - [www.figma.com].png', '2025-10-01', 'test', 'test', 1, '2025-10-01 08:50:55'),
(13, 43, '202412345', 'Rodel', 'option2', 'option1', 'test', '1759308861527-441009461-FireShot Capture 003 - prototype â Figma - [www.figma.com].png', '2025-10-07', 'Rodela ', '9123323', 1, '2025-10-01 08:54:21');

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
(43, 'Cordova Test 2', 'This a cordova test 2', '2025-09-29 20:14:41', '2025-09-29 20:14:41', 'Cordova Sports Complex, Martin Francisco Street, Poblacion, Bangbang, Cordova, Cebu, Central Visayas, 6017, Philippines', 'all', NULL, '[]', 'uploads/events/event-program-43.png', 'this is a sample test', 'test', 'test', 1, 1, 1, 1, 1, 'automatic', '/uploads/qr/event-43.png', NULL, '2025-09-30 12:15:35', '2025-10-01 08:23:12', 10.25062320, 123.94975230),
(44, 'Cordova Public College Sports Fest', 'This is a sports fest', '2025-10-01 15:04:34', '2025-10-01 06:05:00', '', 'all', 'BSIT', '[]', 'uploads/events/event-program-44.png', 'test', 'test', 'test', 1, 1, 1, 1, 1, 'automatic', '/uploads/qr/event-44.png', NULL, '2025-10-02 07:06:06', '2025-10-03 07:57:51', NULL, NULL);

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
  `absence_request` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_attendance`
--

INSERT INTO `event_attendance` (`attendance_id`, `student_id`, `id`, `time_in`, `trivia_time_in`, `time_out`, `created_at`, `updated_at`, `remarks`, `status`, `absence_request`) VALUES
(15, 202412345, 43, '2025-09-30 20:34:49', NULL, '2025-09-30 20:44:37', '2025-09-30 12:34:49', '2025-10-02 10:13:57', '', 1, NULL),
(16, 2024123456, 43, '2025-10-02 15:00:24', NULL, NULL, '2025-10-02 06:53:17', '2025-10-03 08:16:43', '', 0, NULL),
(22, 2024123456, 44, '2025-10-02 15:38:12', '2025-10-03 16:07:09', NULL, '2025-10-02 07:11:12', '2025-10-03 08:07:43', '', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `face_images`
--

CREATE TABLE `face_images` (
  `id` int(11) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `image` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `face_images`
--

INSERT INTO `face_images` (`id`, `student_id`, `image`, `created_at`) VALUES
(15, '202412345', '[-0.13934126496315002,0.1642361730337143,0.06822387129068375,-0.0028064565267413855,-0.03319314122200012,0.032561808824539185,-0.045776307582855225,-0.05129064992070198,0.16079117357730865,-0.08042806386947632,0.3265182077884674,-0.02173396572470665,-0.2153584510087967,-0.19101837277412415,0.055566512048244476,0.16653451323509216,-0.17517457902431488,-0.084400974214077,-0.08417915552854538,-0.0490327924489975,0.06996357440948486,-0.009236203506588936,0.02876889891922474,0.029883544892072678,-0.12559400498867035,-0.39050647616386414,-0.03633183613419533,-0.08835583180189133,0.06003640592098236,-0.08135811239480972,-0.08792479336261749,0.03609063848853111,-0.21865004301071167,-0.06469441950321198,-0.0513010174036026,0.08550447225570679,-0.008678368292748928,0.03702990338206291,0.1195332482457161,-0.06641429662704468,-0.19833002984523773,-0.02549068257212639,0.0537959560751915,0.18995961546897888,0.21836097538471222,0.11360444873571396,-0.032087795436382294,-0.02541482076048851,0.06772232055664062,-0.23094673454761505,0.09210950136184692,0.12393538653850555,0.13130095601081848,0.09403849393129349,-0.001623476855456829,-0.2069244384765625,-0.04659666121006012,0.04625305160880089,-0.15826769173145294,-0.0271290373057127,0.0067583974450826645,-0.09262499213218689,-0.07320059835910797,-0.023578546941280365,0.2715974450111389,0.12950380146503448,-0.15630507469177246,-0.12313195317983627,0.09979002177715302,-0.10914969444274902,0.026327168568968773,0.09878483414649963,-0.12544208765029907,-0.18014881014823914,-0.35743269324302673,0.141658753156662,0.3814959228038788,0.06747926771640778,-0.1847948133945465,-0.018877819180488586,-0.07164929062128067,0.007368459366261959,0.07241465151309967,0.07608312368392944,-0.08012677729129791,-0.030037829652428627,-0.10152962058782578,0.020181706175208092,0.10933146625757217,-0.04234379529953003,-0.030098116025328636,0.23203405737876892,-0.022221865132451057,0.09622822701931,-0.008695053867995739,0.10584531724452972,-0.03575820103287697,0.020839165896177292,-0.09322068095207214,0.03600193187594414,0.0739314928650856,-0.06599866598844528,-0.023407695814967155,0.07100652903318405,-0.14273881912231445,0.096991628408432,0.03621906787157059,0.06463401764631271,0.06991860270500183,0.026698516681790352,-0.12259750813245773,-0.12697143852710724,0.10529232025146484,-0.2755995988845825,0.20956629514694214,0.18133850395679474,0.005718863569200039,0.19116029143333435,0.13153615593910217,0.14488299190998077,0.005064454860985279,-0.03682193532586098,-0.154229074716568,-0.013308488763868809,0.12500424683094025,-0.059529416263103485,0.03752197325229645,0.031326476484537125]', '2025-09-24 06:46:22'),
(16, '2024123456', '[-0.10560236126184464,0.22071239352226257,0.05735732614994049,-0.03966979309916496,-0.05473705753684044,0.005806390196084976,-0.025429638102650642,-0.15296772122383118,0.12976707518100739,-0.022738154977560043,0.2900625169277191,-0.03367858752608299,-0.2342953085899353,-0.2055039405822754,0.019935328513383865,0.13171951472759247,-0.1522655040025711,-0.12390616536140442,-0.04338405653834343,-0.013026644475758076,0.08310454338788986,-0.02067510038614273,0.020102176815271378,0.05353088676929474,-0.14500194787979126,-0.31996408104896545,-0.04521796107292175,-0.09628665447235107,0.016696782782673836,-0.11538992822170258,-0.07482119649648666,0.06137382611632347,-0.2092214971780777,-0.07828352600336075,-0.03188464418053627,0.10759573429822922,-0.013349253684282303,0.0011354675516486168,0.17075221240520477,-0.05380311608314514,-0.21143287420272827,-0.0007103793323040009,-0.003049287013709545,0.21627351641654968,0.24187631905078888,0.02844061888754368,0.015824532136321068,-0.06960906833410263,0.10268894582986832,-0.13986554741859436,0.06042308360338211,0.14588922262191772,0.14632150530815125,0.038409627974033356,-0.0292805228382349,-0.1956588625907898,-0.024256562814116478,0.05864609405398369,-0.19572921097278595,-0.06111214682459831,0.06499139219522476,-0.14050666987895966,-0.05838543921709061,-0.03288756683468819,0.19726529717445374,0.08511137217283249,-0.12001539766788483,-0.1384100615978241,0.12611563503742218,-0.12922954559326172,-0.021282115951180458,0.09797141700983047,-0.1342759132385254,-0.1858624964952469,-0.3341873586177826,0.09295962750911713,0.3854443430900574,0.11663403362035751,-0.26026028394699097,0.002947279019281268,-0.05653722584247589,0.024626366794109344,0.14550083875656128,0.11033172905445099,-0.04146366938948631,0.03663413226604462,-0.13254022598266602,0.0009916105773299932,0.12825965881347656,-0.030147286131978035,-0.07002115249633789,0.21207042038440704,0.0049440073780715466,0.11104164272546768,0.050808604806661606,0.03742951527237892,-0.016045527532696724,0.055315084755420685,-0.10279547423124313,0.051996104419231415,0.00870657991617918,-0.048260580748319626,-0.023361211642622948,0.09795788675546646,-0.1023469865322113,0.13122160732746124,0.05081213265657425,0.07599911093711853,-0.038302626460790634,-0.05527743324637413,-0.0855664387345314,-0.08156754076480865,0.1293659210205078,-0.28582456707954407,0.1719357669353485,0.1467137485742569,-0.038068581372499466,0.1631566435098648,0.13221225142478943,0.11464232951402664,0.014353817328810692,-0.05732132866978645,-0.18655262887477875,-0.014708989299833775,0.1565803587436676,-0.06347793340682983,0.13465802371501923,0.0057498011738061905]', '2025-10-02 06:47:24');

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
(12, '23232', 'sdsad', 'sdsad', 'sdsad', '2025-07-24', '', 0, 1, 2, 0, '', 0, 'rodel123@gmail.com', '$2b$10$jBJzAGXWLziAKPVHwstQ0eHVQ/.92TEgI6BB8KHMEDqxScbsljmZK', 0, '', '2025-07-24 12:27:24'),
(13, '321321', 'dsds', 'dsadsa', 'dsadsad', '2025-07-23', 'Female', 23, 1, 1, 0, '', 0, 'lll@gmail.com', '$2b$10$qKLbZDJ5a.BQmTUkJfuKees9xTmVGsGxICbhubzXaMNnoxmSBdnym', 0, '', '2025-07-24 12:43:58'),
(14, '232', 'asdsad', 'sadsd', 'sadsada', '2025-07-21', 'Female', 21, 1, 1, 232, '', 0, 'asdsad@gmail.com', '$2b$10$SDHdhHqwiBZSiKGksoAboe7LKVImQaKzybWNl3KpvrWB75vS6mwha', 0, '', '2025-07-28 04:45:00'),
(15, '2323', 'asd', 'adasd', 'adsad', '2025-07-28', 'Female', 21, 1, 1, 2323, '', 0, 'dasdas@gmail.com', '$2b$10$5CaWsYtzktC5ZAq8kfGhj.vW9A8U6roC2lAxKVjHMGzHWJmY7u1YK', 0, '', '2025-07-28 06:24:39'),
(16, '202412345', 'Ompad', 'Rodel', 'Pacaldo', '2024-01-03', 'Male', 21, 1, 2, 1, '09123456789', 0, 'ompadrodel03@gmail.com', '$2b$10$5FWysZGYPVyC1agQ.O3T1u5lho50xdh6cNTB8oz3BRmCxZztfZp1a', 1, 'camolinas cordova cebu', '2025-07-28 07:27:21'),
(18, '2024123456', 'Celades', 'Lovely Jean', 'Garcia', '2025-10-01', 'Female', 23, 2, 1, 1, '', 0, 'rodel@wpcrank.com', '$2b$10$Do4293zbDh3eA3Qpjh7xZeupNv4oK8EzGpjJjXSykVfct5Us6Yb0C', 1, '', '2025-10-02 06:41:50');

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
(2, 202412345, NULL, 13, '2025-10-01 16:54:21', 1, 43);

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
(1, 'Honey Margs', '', 'Almojallas', 'honey123@gmail.com', '12345', 1, 0);

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
(9, '202412345', 'option1', 'Gaining experience', '', 'Yes', 'test', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-01 07:00:02', 43, 0),
(10, '202412345', 'option1', 'Gaining experience', '', 'Yes', 'test', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-01 08:37:27', 43, 0),
(11, '202412345', 'option1', 'Gaining experience', '', 'Yes', 'test', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-01 08:43:51', 43, 0),
(12, '202412345', 'option1', 'Gaining experience', '', 'Yes', 'test', 'Event planning', '', 'Yes', 'Leader', '', 1, '2025-10-01 08:45:20', 43, 0);

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
-- Indexes for table `student_request`
--
ALTER TABLE `student_request`
  ADD PRIMARY KEY (`request_id`);

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
  MODIFY `absence_requests_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `event_attendance`
--
ALTER TABLE `event_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `face_images`
--
ALTER TABLE `face_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `student_request`
--
ALTER TABLE `student_request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `volunteers`
--
ALTER TABLE `volunteers`
  MODIFY `volunteered_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sections_ibfk_2` FOREIGN KEY (`year_id`) REFERENCES `year_levels` (`year_id`) ON DELETE CASCADE;

--
-- Constraints for table `year_levels`
--
ALTER TABLE `year_levels`
  ADD CONSTRAINT `year_levels_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
