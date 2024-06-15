-- MariaDB dump 10.19  Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: std-mysql.ist.mospolytech.ru    Database: std_2061_exam
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('b19b29a8c2f3');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book_genre` (
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `fk_book_genre_genre_id_genres` (`genre_id`),
  CONSTRAINT `fk_book_genre_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_book_genre_genre_id_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre`
--

LOCK TABLES `book_genre` WRITE;
/*!40000 ALTER TABLE `book_genre` DISABLE KEYS */;
INSERT INTO `book_genre` VALUES (31,1),(34,1),(36,1),(43,1),(44,1),(31,2),(34,2),(35,2),(36,2),(37,2),(38,2),(39,2),(41,2),(44,2),(37,4),(38,4),(39,4),(40,4),(41,4),(42,4),(43,4);
/*!40000 ALTER TABLE `book_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_desc` text NOT NULL,
  `year` varchar(4) NOT NULL,
  `pub_house` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `volume` int(11) NOT NULL,
  `rating_sum` int(11) NOT NULL,
  `rating_num` int(11) NOT NULL,
  `image_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_image_id_images` (`image_id`),
  CONSTRAINT `fk_books_image_id_images` FOREIGN KEY (`image_id`) REFERENCES `images` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (31,'Эмма','* Очаровательна \r\n* Остроумна\r\n* Обеспеченна','1815','АААА','Джейн Остин',500,12,3,'d2aceb39-e9d2-486f-aba1-ad44e8ea25fd'),(34,'Великий Гэтсби','**Хорошая книга**','1925','ААА','Ф.Скотт Фицджеральд',256,10,2,'dba09995-ff67-4579-816f-e2daf288acdf'),(35,'Тарас Бульба','*Я тебя породил - я тебя и убью*','1835','МИРГОРОД','Н.В.Гоголь',400,5,1,'b2014bb4-04fe-437a-bf6e-9a6007cf4bf0'),(36,'Большие надежды','*Следует верить только фактам, а не полагаться на догадки*','1860','ААА','Чарльз Диккенс',500,10,2,'b9efae20-c068-4ec3-81cc-431796ba9072'),(37,'Гарри Поттер и философский камень','Первая из 7 книга про мальчика, *который выжил*','1997','Супер','Дж.К.Роулинг',600,0,0,'6846cfef-bac3-423b-b043-5dc116a74657'),(38,'Гарри Поттер и тайная комната','Вторая книга из серии про знаменитого волшебника','1998','ОООО','Дж.К.Роулинг',540,1,1,'ce034955-0f0b-4830-bab9-e0af8d8a4549'),(39,'Гарри Поттер и узник Азкабана','Третья книга из серии','1999','ООО','Дж.К.Роулинг',590,4,1,'7a30a9ab-39c2-46b8-8c7f-8c2f04b4e6cb'),(40,'Гарри Поттер и Кубок огня','Гарри Поттер, Рон и Гермиона возвращаются на четвёртый курс школы чародейства и волшебства Хогвартс. При таинственных обстоятельствах Гарри был отобран в число участников опасного соревнования — Турнира Трёх Волшебников, однако проблема в том, что все его соперники — намного старше и сильнее.','2000','РОСМЭН','Дж.К.Роулинг',704,8,2,'1a33b1c0-d0c4-43a1-a699-e65582b0a06a'),(41,'Гарри Поттер и Орден Феникса','Гарри проводит свой пятый год обучения в школе Хогвартс и обнаруживает, что многие из членов волшебного сообщества отрицают сам факт недавнего состязания юного волшебника с воплощением вселенского зла Волдемортом, делая вид, что не имеют ни малейшего представления о том, что злодей вернулся.','2003','Bloomsbury Scholastic Raincoast Росмэн-Издат','Дж.К.Роулинг',896,9,2,'255c01de-f699-477c-b664-d73308e86cc3'),(42,'Гарри Поттер и Принц-полукровка','Теперь не только мир волшебников, но и мир маглов ощущает на себе все возрастающую силу Волан-де-Морта, а Хогвартс уже никак не назовешь надежным убежищем, каким он был раньше. Гарри подозревает, что в самом замке затаилась некая опасность, но Дамблдор больше сосредоточен на том, чтобы подготовить его к финальной схватке, которая, как он знает, уже не за горами. Вместе они пытаются разгадать секрет бессмертия Волан-де-Морта, а для этого Дамблдор приглашает на должность преподавателя по зельеварению своего старинного друга и коллегу — профессора Горация Слизнорта, который обожает устраивать вечеринки для избранных и гордится своими обширными связями в высших кругах. Но этот бонвиван и не подозревает, что как раз от него Дамблдор надеется заполучить самую важную информацию о крестражах.','2005','Bloomsbury Scholastic Raincoast Росмэн-Издат','Дж.К.Роулинг',672,10,2,'e4667146-3913-4fad-86bb-f1e5797df83d'),(43,'Гарри Поттер и Дары Смерти','**Книга** \"Гарри Поттер и дары смерти\" рассказывает о седьмом годе обучения Гарри и его друзей в школе магии и волшебства Хогвартс. Пожалуй, это — самая захватывающая, интригующая и занимательная из всех книг про Гарри Поттера, ведь она завершает цикл про знаменитого волшебника в очках.','2007','Махаон','Дж.К.Роулинг',704,5,1,'45f7d7a4-112b-4a75-b8d8-22140c05db30'),(44,'Отцы и дети','**Актуально во все времена**','1860','ЗЗЗ','И.С.Тургенев',500,5,1,'7457f726-4c37-4b2a-baa6-7f1485c40bf6');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mark` int(11) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `book_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comments_book_id_books` (`book_id`),
  KEY `fk_comments_user_id_users` (`user_id`),
  CONSTRAINT `fk_comments_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_comments_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (24,5,'# Всем советую!','2023-06-19 14:09:29',31,1),(25,5,'Автор запутывает вас с самого начала, всё очень круто!!!','2023-06-19 14:14:19',36,1),(26,3,'Прикольно конечно, но, на мой взгляд, роман Джейн Остин \"Гордость и предубеждение\" интереснее','2023-06-19 14:19:06',31,2),(27,4,'Мне понравился на четверочку','2023-06-19 14:22:10',31,3),(30,5,'# Просто класс','2023-06-19 15:16:59',36,2),(36,5,'## Очень круто','2023-06-20 10:40:06',34,1),(39,5,'dsfdsffsd','2023-06-27 09:58:29',34,3),(40,5,'## Просто вау','2023-06-27 11:33:14',40,1),(41,5,'## Просто вау','2023-06-30 06:27:16',44,1),(45,4,'Параша','2024-05-20 13:45:27',39,1),(46,5,'Мне нравится','2024-06-13 09:35:00',35,1),(47,5,'авававав','2024-06-14 23:34:11',42,1),(48,4,'Понравилось произведение','2024-06-15 12:08:36',41,1),(51,5,'Круто!','2024-06-15 12:43:17',42,3),(52,3,'Такое себе','2024-06-15 12:43:47',40,3),(53,5,'&lt;script&gt;alert(\'XSS\');&lt;/script&gt;','2024-06-15 12:48:42',41,2),(54,5,'Хороший рассказ','2024-06-15 13:02:44',43,2),(55,1,'Плохо','2024-06-15 13:06:37',38,2);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genres_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (2,'Драма'),(1,'Роман'),(3,'Ужасы'),(4,'Фантастика');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `id` varchar(100) NOT NULL,
  `file_name` varchar(100) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `md5_hash` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_images_md5_hash` (`md5_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES ('1a33b1c0-d0c4-43a1-a699-e65582b0a06a','3F3F3F3F3F3F3F.webp','image/webp','294d0c52bd6d31f43883b8064e58ed83'),('255c01de-f699-477c-b664-d73308e86cc3','Harry_Potter_and_the_Order_of_the_Phoenix__movie.jpg','image/jpeg','114f08cf7d60bf9356352af865948182'),('45f7d7a4-112b-4a75-b8d8-22140c05db30','203px-Harry_Potter_and_the_Deathly_Hallows._Part_2__movie.jpg','image/jpeg','3bd1fdf5a9a11595407ac12e8e9de37c'),('6846cfef-bac3-423b-b043-5dc116a74657','Harry_Potter_and_the_Philosophers_Stone__movie.jpg','image/jpeg','6205697c87b5dafce058fb81d3e2e021'),('7457f726-4c37-4b2a-baa6-7f1485c40bf6','cover.webp','image/webp','3c8a01bea184c313738a0ba1af7ac419'),('7a30a9ab-39c2-46b8-8c7f-8c2f04b4e6cb','8903.jpg','image/jpeg','878d77628b967c33a7659b3951225c0a'),('b2014bb4-04fe-437a-bf6e-9a6007cf4bf0','19429600.jpg','image/jpeg','61a1907a62243f6095cbbc12faed0c8d'),('b706efc6-dc36-4865-91bf-8e162a7af741','a-stack-of-books-an-open-book-and-a-pencil-school-supplies_69317-595.avif','image/avif','05599bf65a692801776e6144281d74b4'),('b9efae20-c068-4ec3-81cc-431796ba9072','0_24b9140b3bae9009f5b97dc8a746f11e_1360260846.jpg','image/jpeg','09ee7b9d8e51417e8048c7d875899ec9'),('ce034955-0f0b-4830-bab9-e0af8d8a4549','Harry_Potter_and_the_Chamber_of_Secrets__movie.jpg','image/jpeg','7d0cd18c27497dc7b8ac62b4bd038a2c'),('d2aceb39-e9d2-486f-aba1-ad44e8ea25fd','2020.jpg','image/jpeg','023c39e602f455c54736fdf26efc3a8c'),('dba09995-ff67-4579-816f-e2daf288acdf','125259.jpg','image/jpeg','b23ab2240be2250587abe978cfa5ccd8'),('e4667146-3913-4fad-86bb-f1e5797df83d','5518.jpg','image/jpeg','2bb2ee625a24c5122bcf20cea13a405c');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Администратор','суперпользователь, имеет полный доступ к системе, в том числе к созданию и удалению книг'),(2,'Модератор','может редактировать данные книг и производить модерацию рецензий'),(3,'Пользователь','может оставлять рецензии');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `login` varchar(100) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','dima','dipo','admin','scrypt:32768:8:1$3INtdy3kTMYUzFLl$e3ac7ff104ec8b86df8d214a2385309fedfc5421b1f4b40bf167751437409b205c795b4ae8454dc6b30cb4634df7843f3f57a16772af1fa71788dc65ae1a1a82',1),(2,'moder','dima','dipo','moder','scrypt:32768:8:1$3INtdy3kTMYUzFLl$e3ac7ff104ec8b86df8d214a2385309fedfc5421b1f4b40bf167751437409b205c795b4ae8454dc6b30cb4634df7843f3f57a16772af1fa71788dc65ae1a1a82',2),(3,'user','dima','dipo','user','scrypt:32768:8:1$3INtdy3kTMYUzFLl$e3ac7ff104ec8b86df8d214a2385309fedfc5421b1f4b40bf167751437409b205c795b4ae8454dc6b30cb4634df7843f3f57a16772af1fa71788dc65ae1a1a82',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-15 16:31:03
