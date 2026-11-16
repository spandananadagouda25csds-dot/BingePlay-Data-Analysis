-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bingeplay
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `shows`
--

DROP TABLE IF EXISTS `shows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shows` (
  `show_id` varchar(10) NOT NULL,
  `title` varchar(150) NOT NULL,
  `category` varchar(30) NOT NULL,
  `language` varchar(30) NOT NULL,
  `release_year` int NOT NULL,
  `imdb_rating` decimal(3,1) NOT NULL,
  `is_original` tinyint NOT NULL,
  `min_plan` varchar(20) NOT NULL,
  PRIMARY KEY (`show_id`),
  KEY `idx_category` (`category`),
  KEY `idx_language` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shows`
--

LOCK TABLES `shows` WRITE;
/*!40000 ALTER TABLE `shows` DISABLE KEYS */;
INSERT INTO `shows` VALUES ('S001','Kahani Ghar Ghar Ki','Action','English',2021,6.9,0,'Basic'),('S002','Show Special 4','Romance','Tamil',2020,6.9,0,'Basic'),('S003','Karnataka Kings','Drama','Hindi',2023,6.7,0,'Basic'),('S004','Show Special 20','Drama','Tamil',2022,6.0,0,'Family'),('S005','Show Special 27','Thriller','Bengali',2023,7.9,1,'Premium'),('S006','Show Special 8','Drama','Hindi',2020,8.5,1,'Basic'),('S007','Show Special 17','Drama','Kannada',2019,5.6,0,'Premium'),('S008','Show Special 7','Kids','Bengali',2019,6.0,0,'Premium'),('S009','Kollywood Kings','Drama','English',2023,5.3,0,'Premium'),('S010','Naagin Chronicles','Documentary','Telugu',2023,7.3,1,'Premium'),('S011','Vizag Vibes','Comedy','Tamil',2022,7.0,0,'Basic'),('S012','Show Special 35','Romance','English',2018,6.8,1,'Premium'),('S013','Show Special 22','Reality','Malayalam',2024,9.3,1,'Basic'),('S014','Data Detective','Thriller','Hindi',2022,6.7,0,'Basic'),('S015','Show Special 28','Drama','Kannada',2019,8.9,1,'Basic'),('S016','Show Special 32','Drama','English',2024,7.2,1,'Basic'),('S017','Show Special 38','Drama','Hindi',2020,8.9,1,'Premium'),('S018','Mumbai Startup','Reality','Tamil',2018,7.5,1,'Basic'),('S019','Founder Diaries','Romance','English',2023,7.3,0,'Basic'),('S020','Malabar Mysteries','Reality','Hindi',2019,7.5,1,'Basic'),('S021','Corporate Chai','Kids','Malayalam',2021,6.3,0,'Basic'),('S022','Show Special 12','Drama','Hindi',2018,8.0,1,'Basic'),('S023','Andhera Kayam Rahe','Action','Tamil',2019,8.0,1,'Basic'),('S024','Show Special 18','Romance','Hindi',2018,7.4,1,'Basic'),('S025','Show Special 37','Comedy','Hindi',2024,6.7,0,'Basic'),('S026','Show Special 3','Reality','Hindi',2019,7.1,0,'Premium'),('S027','Kochi Nights','Thriller','Bengali',2024,7.2,0,'Premium'),('S028','Bhindi Bazaar','Comedy','Hindi',2020,7.3,0,'Basic'),('S029','Bollywood Bootcamp','Thriller','Tamil',2018,4.5,0,'Premium'),('S030','Ishq Deewana','Kids','Malayalam',2018,8.1,0,'Basic'),('S031','Cricket League','Romance','Hindi',2021,7.2,0,'Basic'),('S032','Show Special 29','Romance','Hindi',2018,5.9,0,'Family'),('S033','Show Special 33','Reality','Telugu',2018,8.5,1,'Basic'),('S034','Show Special 34','Thriller','Tamil',2018,8.4,0,'Premium'),('S035','Sundarban Secrets','Drama','Kannada',2023,6.4,0,'Basic'),('S036','Show Special 11','Thriller','Hindi',2022,8.0,1,'Premium'),('S037','Telugu Tycoon','Romance','Hindi',2023,4.3,0,'Basic'),('S038','Chennai Chills','Romance','Telugu',2019,7.1,0,'Basic'),('S039','Show Special 0','Comedy','Telugu',2018,7.4,0,'Family'),('S040','Bombay Bites','Action','Tamil',2024,4.6,0,'Basic'),('S041','Show Special 30','Romance','Tamil',2022,5.6,0,'Basic'),('S042','Mysore Mystique','Reality','Tamil',2024,7.3,1,'Basic'),('S043','Kolkata Chronicles','Thriller','English',2019,6.9,0,'Basic'),('S044','Techie Talks','Drama','Hindi',2020,8.7,0,'Basic'),('S045','Rangeela Ratri','Comedy','Hindi',2023,7.8,1,'Basic'),('S046','Show Special 9','Romance','Hindi',2018,7.5,1,'Premium'),('S047','Filmy Files','Thriller','Hindi',2024,6.7,0,'Premium'),('S048','The Bangalore Bug','Drama','English',2022,8.5,0,'Premium'),('S049','Tamil Nadu Nights','Drama','Malayalam',2023,7.3,1,'Premium'),('S050','Show Special 10','Drama','Bengali',2020,6.5,0,'Premium'),('S051','Startup Sundar','Documentary','English',2019,5.3,0,'Family'),('S052','Bengaluru Beats','Comedy','English',2021,7.4,0,'Family'),('S053','Rangoon Nights','Drama','English',2020,7.1,0,'Premium'),('S054','Show Special 39','Drama','Hindi',2019,9.3,1,'Basic'),('S055','Bandra Blues','Drama','Telugu',2020,5.8,0,'Basic'),('S056','Show Special 2','Drama','Hindi',2018,8.0,1,'Premium'),('S057','Kesari Kaand','Thriller','Malayalam',2021,6.1,0,'Basic'),('S058','Code Red Delhi','Documentary','Hindi',2020,4.6,0,'Premium'),('S059','Thiruvananthapuram Tales','Comedy','Hindi',2020,6.8,0,'Premium'),('S060','Hyderabad Heights','Comedy','Telugu',2023,5.9,0,'Basic'),('S061','Show Special 14','Thriller','English',2019,8.8,1,'Premium'),('S062','Metro Nights','Kids','English',2020,5.2,0,'Family'),('S063','Rajini Returns','Drama','Tamil',2019,6.9,0,'Family'),('S064','Madurai Masala','Reality','Malayalam',2020,7.8,1,'Basic'),('S065','Show Special 21','Reality','Hindi',2021,6.5,0,'Premium'),('S066','Dil Dosti Duniya','Action','English',2022,5.8,0,'Basic'),('S067','Delhi Diaries','Kids','Hindi',2019,8.0,1,'Basic'),('S068','Roadies Reloaded','Thriller','English',2018,6.4,0,'Premium'),('S069','The Prime Minister','Thriller','Kannada',2021,5.9,0,'Premium'),('S070','Silicon Bombay','Action','Hindi',2019,7.6,0,'Basic'),('S071','Bengal Blues','Drama','Hindi',2018,6.0,0,'Premium'),('S072','Show Special 1','Documentary','Telugu',2020,7.3,0,'Basic'),('S073','Coorg Chronicles','Action','English',2021,5.4,0,'Premium'),('S074','Kerala Chronicles','Drama','Malayalam',2023,6.8,0,'Basic'),('S075','Underworld Empire','Thriller','Telugu',2019,7.8,0,'Premium'),('S076','Show Special 5','Drama','Kannada',2022,7.7,1,'Premium'),('S077','Chennai Express Lane','Drama','Kannada',2021,7.3,1,'Premium'),('S078','Show Special 13','Thriller','Hindi',2020,6.7,0,'Premium'),('S079','Show Special 25','Documentary','Kannada',2023,6.1,0,'Family'),('S080','Show Special 31','Kids','Hindi',2022,7.8,1,'Basic'),('S081','Yeh Rishta Kya Kehlata Hai','Romance','Hindi',2018,8.1,1,'Premium'),('S082','Show Special 16','Thriller','Malayalam',2024,6.2,0,'Basic'),('S083','Mumbai Mafia','Thriller','Hindi',2019,7.6,1,'Premium'),('S084','Show Special 24','Documentary','Hindi',2019,7.0,0,'Basic'),('S085','Mera Naam Josh','Comedy','Hindi',2018,6.6,0,'Basic'),('S086','The Great Indian Kitchen Show','Comedy','English',2021,7.5,0,'Premium'),('S087','Show Special 15','Drama','Hindi',2020,8.1,0,'Premium'),('S088','Rayalaseema Raga','Thriller','Kannada',2019,5.5,0,'Premium'),('S089','Show Special 6','Romance','Telugu',2021,6.5,0,'Basic'),('S090','Howrah Heights','Romance','Malayalam',2023,5.0,0,'Family'),('S091','Shaadi Wali Baat','Drama','Hindi',2024,6.4,0,'Premium'),('S092','Show Special 26','Thriller','Hindi',2018,7.1,0,'Basic'),('S093','Show Special 23','Kids','Bengali',2021,8.3,0,'Basic'),('S094','Andhra Diaries','Romance','Hindi',2020,7.0,0,'Basic'),('S095','Punjab Da Puttar','Kids','Tamil',2018,7.8,0,'Premium'),('S096','Show Special 36','Comedy','Hindi',2023,7.7,1,'Basic'),('S097','Show Special 19','Thriller','Hindi',2019,6.5,0,'Basic'),('S098','Hampi Heritage','Kids','Malayalam',2022,8.6,0,'Premium'),('S099','Rabindra Retrospect','Thriller','Hindi',2024,7.6,0,'Basic'),('S100','Munnar Mist','Thriller','English',2023,7.0,0,'Basic');
/*!40000 ALTER TABLE `shows` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-15 19:08:16
