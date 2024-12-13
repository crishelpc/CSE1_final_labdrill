-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: hospice_patient_care
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `healthprofessionals`
--

DROP TABLE IF EXISTS `healthprofessionals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `healthprofessionals` (
  `staffID` int NOT NULL AUTO_INCREMENT,
  `staffName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staffPhone` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`staffID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `healthprofessionals`
--

LOCK TABLES `healthprofessionals` WRITE;
/*!40000 ALTER TABLE `healthprofessionals` DISABLE KEYS */;
INSERT INTO `healthprofessionals` VALUES (1,'Mr. Ubaldo Yost PhD','(712) 583-2481'),(2,'Candida Herzog','912.738.5624'),(3,'Erica Watsica','(469) 215-8372'),(4,'Prof. Lee Deckow Jr.','(837) 621-5473'),(5,'Trevion Wisoky','365.489.7124'),(6,'Mckenzie Doyle I','584.631.8274'),(7,'Pearline Wiegand','(309) 472-5182'),(8,'Dr. Susie Lemke IV','(753) 825-1974'),(9,'Leonel Stamm','(669) 473-2158'),(10,'Morton Stroman','(834) 761-2493'),(11,'Marlen Prohaska','289.193.5741'),(12,'Arne Collier','(907) 528-6194'),(13,'Bertha Dooley','584.672.2395'),(14,'Mr. Nathen Corkery MD','729.354.8712'),(15,'Mr. Eleazar Hettinger','369.295.7483'),(16,'Ms. Mariela Shanahan III','718.452.9831'),(17,'Mina Ryan','451.823.9471'),(18,'Dr. Dorian Ward','901.734.8923'),(19,'Cecilia DuBuque','(819) 295-8473'),(20,'Samir Baumbach','035.516.8499'),(21,'Mrs. Betsy Miller IV','(258) 179-5204'),(22,'Derek Rath','589.019.6424'),(23,'Nellie Wisoky','582.269.1842'),(24,'Cindy Kovacek','295.504.9832'),(25,'Keith Schamberger MD','038.417.2831');
/*!40000 ALTER TABLE `healthprofessionals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patientadmissions`
--

DROP TABLE IF EXISTS `patientadmissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patientadmissions` (
  `admissionID` int NOT NULL AUTO_INCREMENT,
  `patientID` int NOT NULL,
  `dateOfAdmission` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dateOfDischarge` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`admissionID`),
  KEY `patientID` (`patientID`),
  CONSTRAINT `PatientAdmissions_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patients` (`patientID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patientadmissions`
--

LOCK TABLES `patientadmissions` WRITE;
/*!40000 ALTER TABLE `patientadmissions` DISABLE KEYS */;
INSERT INTO `patientadmissions` VALUES (1,4,'1983-01-24','1996-07-14'),(2,5,'2009-02-16','2019-09-20'),(3,5,'2004-05-27','1979-08-20'),(4,6,'1976-09-29','1971-04-07'),(5,9,'1978-09-15','1992-04-20'),(6,3,'2007-11-08','2008-12-01'),(7,6,'2015-10-02','1979-08-05'),(8,1,'1986-02-01','1989-02-22'),(9,8,'2018-12-23','2024-03-30'),(10,3,'1990-01-15','1984-02-01'),(11,5,'1978-10-26','1983-06-14'),(12,1,'1985-09-22','2017-11-02'),(13,1,'2001-11-06','2004-08-19'),(14,1,'2010-02-08','2013-06-21'),(15,8,'2022-12-01','1972-02-09'),(16,7,'2004-10-14','1999-10-17'),(17,5,'1978-05-08','2015-04-06'),(18,9,'1985-01-08','2021-10-24'),(19,6,'2000-10-06','2010-12-06'),(20,8,'1993-12-31','1998-03-21'),(21,2,'1996-08-18','1994-07-24'),(22,8,'1970-08-17','1983-11-29'),(23,8,'1981-03-19','1987-04-30'),(24,8,'1975-06-07','2021-05-27'),(25,4,'1984-05-13','2016-10-25'),(27,21,'2024-12-12','2024-12-15'),(28,2,'2022-01-01','2022-02-02');
/*!40000 ALTER TABLE `patientadmissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patientID` int NOT NULL AUTO_INCREMENT,
  `patientFirstName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patientLastName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patientHomePhone` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientEmailAddress` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`patientID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'Aitor','Reina','(361) 548-9276','esarabia@gmail.com'),(2,'Daniela','Linares','(425) 873-6210','veliz.leire@gmail.com'),(3,'Gael','Millan','(510) 762-4931','rsierra@hotmail.com'),(4,'Ona','Clemente','(718) 654-3209','ramos.francisco@hotmail.com'),(5,'Jimena','Banda','(204) 391-8752','serra.yeray@hotmail.com'),(6,'Vega','Macias','(307) 924-6837','balderas.gerard@hotmail.com'),(7,'Sofia','Vazquez','(412) 705-8291','jan35@hotmail.com'),(8,'Unai','Rolon','(563) 217-6948','adam.gutierrez@yahoo.com'),(9,'Victoria','Mejia','(319) 308-4569','saavedra.francisco@yahoo.com'),(10,'Cesar','Peralta','(215) 943-6712','martin.rivero@hotmail.com'),(11,'Ander','Salcido','(602) 489-7125','javier.juarez@hotmail.com'),(12,'Eric','Urrutia','(873) 504-6891','tdominguez@gmail.com'),(13,'Ignacio','Hernandez','(625) 384-9261','agosto.erik@hotmail.com'),(14,'Celia','Delgado','(439) 517-8260','adrian.ocampo@yahoo.com'),(15,'Eduardo','Casas','(718) 619-3542','montez.jordi@yahoo.com'),(16,'Eva','Hernandez','(928) 273-4816','martina.mondragon@gmail.com'),(17,'Cristina','Mejia','(415) 839-7162','miranda.mireia@hotmail.com'),(18,'Marti','Luevano','(737) 904-2681','yperez@hotmail.com'),(19,'Eva','Quinones','(603) 792-1548','hurtado.jesus@yahoo.com'),(20,'Gabriela','Luque','(517) 845-2971','borrego.diego@gmail.com'),(21,'Nayara','Ledesma','(832) 953-4018','escudero.antonio@hotmail.com'),(22,'Aroa','Armenta','(347) 786-2093','folivas@yahoo.com'),(23,'Nerea','Robles','(586) 419-5872','juan40@hotmail.com'),(24,'Juan','Villegas','(927) 531-6894','apichardo@gmail.com'),(25,'Oriol','Razo','(678) 438-7209','jpons@gmail.com');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treatments`
--

DROP TABLE IF EXISTS `treatments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treatments` (
  `treatmentID` int NOT NULL AUTO_INCREMENT,
  `patientID` int NOT NULL,
  `staffID` int DEFAULT NULL,
  `treatmentDescription` text COLLATE utf8mb4_unicode_ci,
  `treatmentStatus` enum('Pending','Ongoing','Completed') COLLATE utf8mb4_unicode_ci DEFAULT 'Pending',
  PRIMARY KEY (`treatmentID`),
  KEY `patientID` (`patientID`),
  KEY `staffID` (`staffID`),
  CONSTRAINT `Treatments_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patients` (`patientID`) ON DELETE CASCADE,
  CONSTRAINT `Treatments_ibfk_2` FOREIGN KEY (`staffID`) REFERENCES `healthprofessionals` (`staffID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatments`
--

LOCK TABLES `treatments` WRITE;
/*!40000 ALTER TABLE `treatments` DISABLE KEYS */;
INSERT INTO `treatments` VALUES (1,2,7,'Physical therapy for shoulder pain, focusing on range-of-motion exercises and muscle strengthening.','Ongoing'),(2,2,7,'Chiropractic adjustments for lower back pain, targeting spinal alignment and nerve decompression.','Ongoing'),(3,6,9,'Post-operative rehabilitation following knee replacement surgery, including gradual weight-bearing exercises.','Ongoing'),(4,2,1,'Nutritional counseling for weight management, with a personalized meal plan and health coaching.','Pending'),(5,8,3,'Massage therapy for stress relief and muscle tension, using deep tissue techniques.','Ongoing'),(6,3,3,'Final session of guided meditation for stress reduction and improved mindfulness.','Completed'),(7,7,12,'Acupuncture sessions for chronic migraines, aimed at reducing frequency and severity.','Ongoing'),(8,6,8,'Skin care consultation for acne treatment, focusing on prescription topical treatments and lifestyle changes.','Pending'),(9,5,1,'Dental cleaning and fluoride treatment for preventative oral health care.','Completed'),(10,2,6,'Orthodontic evaluation and initial fitting for clear aligners to correct misalignment.','Pending'),(11,7,9,'Speech therapy for post-stroke patients, focusing on articulation and communication skills.','Ongoing'),(12,9,3,'Physical therapy for ankle sprain recovery, including mobility and stability exercises.','Pending'),(13,5,8,'Dermatological consultation for psoriasis management, with a focus on topical therapies and lifestyle advice.','Pending'),(14,3,3,'Follow-up session for chronic back pain, including therapeutic ultrasound and manual therapy.','Completed'),(15,8,4,'Prenatal massage therapy for lower back pain and improved circulation during pregnancy.','Ongoing'),(16,1,11,'Psychological counseling session focusing on managing anxiety and coping strategies.','Ongoing'),(17,3,3,'Post-physical trauma recovery plan with gradual strength training and functional movements.','Completed'),(18,4,7,'Custom orthotic fitting to address plantar fasciitis and improve gait mechanics.','Completed'),(19,8,7,'Ongoing physical therapy for rotator cuff injury, focusing on shoulder mobility and pain relief.','Ongoing'),(20,7,21,'Pediatric occupational therapy for sensory processing challenges.','Pending'),(22,4,4,'Lifestyle coaching for diabetes management, including dietary adjustments and exercise recommendations.','Pending'),(23,6,1,'Hearing aid fitting and adjustment for improved auditory function.','Pending'),(24,3,1,'Final evaluation after physical therapy for frozen shoulder, with emphasis on maintaining mobility.','Completed'),(25,6,5,'Chiropractic care for neck pain caused by poor posture, including adjustments and ergonomic education.','Ongoing');
/*!40000 ALTER TABLE `treatments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-13 19:45:02
