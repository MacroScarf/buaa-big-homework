-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: netshop
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add area',7,'add_area'),(26,'Can change area',7,'change_area'),(27,'Can delete area',7,'delete_area'),(28,'Can view area',7,'view_area'),(29,'Can add user info',8,'add_userinfo'),(30,'Can change user info',8,'change_userinfo'),(31,'Can delete user info',8,'delete_userinfo'),(32,'Can view user info',8,'view_userinfo'),(33,'Can add follow shop',9,'add_followshop'),(34,'Can change follow shop',9,'change_followshop'),(35,'Can delete follow shop',9,'delete_followshop'),(36,'Can view follow shop',9,'view_followshop'),(37,'Can add favorite good',10,'add_favoritegood'),(38,'Can change favorite good',10,'change_favoritegood'),(39,'Can delete favorite good',10,'delete_favoritegood'),(40,'Can view favorite good',10,'view_favoritegood'),(41,'Can add address',11,'add_address'),(42,'Can change address',11,'change_address'),(43,'Can delete address',11,'delete_address'),(44,'Can view address',11,'view_address'),(45,'Can add user footprint',12,'add_userfootprint'),(46,'Can change user footprint',12,'change_userfootprint'),(47,'Can delete user footprint',12,'delete_userfootprint'),(48,'Can view user footprint',12,'view_userfootprint'),(49,'Can add cart item',13,'add_cartitem'),(50,'Can change cart item',13,'change_cartitem'),(51,'Can delete cart item',13,'delete_cartitem'),(52,'Can view cart item',13,'view_cartitem'),(53,'Can add category',14,'add_category'),(54,'Can change category',14,'change_category'),(55,'Can delete category',14,'delete_category'),(56,'Can view category',14,'view_category'),(57,'Can add color',15,'add_color'),(58,'Can change color',15,'change_color'),(59,'Can delete color',15,'delete_color'),(60,'Can view color',15,'view_color'),(61,'Can add comment',16,'add_comment'),(62,'Can change comment',16,'change_comment'),(63,'Can delete comment',16,'delete_comment'),(64,'Can view comment',16,'view_comment'),(65,'Can add good detail',17,'add_gooddetail'),(66,'Can change good detail',17,'change_gooddetail'),(67,'Can delete good detail',17,'delete_gooddetail'),(68,'Can view good detail',17,'view_gooddetail'),(69,'Can add goods',18,'add_goods'),(70,'Can change goods',18,'change_goods'),(71,'Can delete goods',18,'delete_goods'),(72,'Can view goods',18,'view_goods'),(73,'Can add goods detail name',19,'add_goodsdetailname'),(74,'Can change goods detail name',19,'change_goodsdetailname'),(75,'Can delete goods detail name',19,'delete_goodsdetailname'),(76,'Can view goods detail name',19,'view_goodsdetailname'),(77,'Can add inventory',20,'add_inventory'),(78,'Can change inventory',20,'change_inventory'),(79,'Can delete inventory',20,'delete_inventory'),(80,'Can view inventory',20,'view_inventory'),(81,'Can add size',21,'add_size'),(82,'Can change size',21,'change_size'),(83,'Can delete size',21,'delete_size'),(84,'Can view size',21,'view_size'),(85,'Can add order',22,'add_order'),(86,'Can change order',22,'change_order'),(87,'Can delete order',22,'delete_order'),(88,'Can view order',22,'view_order'),(89,'Can add order item',23,'add_orderitem'),(90,'Can change order item',23,'change_orderitem'),(91,'Can delete order item',23,'delete_orderitem'),(92,'Can view order item',23,'view_orderitem'),(93,'Can add shop',24,'add_shop'),(94,'Can change shop',24,'change_shop'),(95,'Can delete shop',24,'delete_shop'),(96,'Can view shop',24,'view_shop'),(97,'Can add used goods',25,'add_usedgoods'),(98,'Can change used goods',25,'change_usedgoods'),(99,'Can delete used goods',25,'delete_usedgoods'),(100,'Can view used goods',25,'view_usedgoods'),(101,'Can add used goods detail',26,'add_usedgoodsdetail'),(102,'Can change used goods detail',26,'change_usedgoodsdetail'),(103,'Can delete used goods detail',26,'delete_usedgoodsdetail'),(104,'Can view used goods detail',26,'view_usedgoodsdetail');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cartapp_cartitem`
--

DROP TABLE IF EXISTS `cartapp_cartitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cartapp_cartitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goodsid` int unsigned NOT NULL,
  `colorid` int unsigned NOT NULL,
  `sizeid` int unsigned NOT NULL,
  `count` int unsigned NOT NULL,
  `isdelete` tinyint(1) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cartapp_cartitem_user_id_9785fb22_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `cartapp_cartitem_user_id_9785fb22_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`),
  CONSTRAINT `cartapp_cartitem_chk_1` CHECK ((`goodsid` >= 0)),
  CONSTRAINT `cartapp_cartitem_chk_2` CHECK ((`colorid` >= 0)),
  CONSTRAINT `cartapp_cartitem_chk_3` CHECK ((`sizeid` >= 0)),
  CONSTRAINT `cartapp_cartitem_chk_4` CHECK ((`count` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartapp_cartitem`
--

LOCK TABLES `cartapp_cartitem` WRITE;
/*!40000 ALTER TABLE `cartapp_cartitem` DISABLE KEYS */;
INSERT INTO `cartapp_cartitem` VALUES (2,1,1,1,1,0,1),(3,3,7,9,3,0,2);
/*!40000 ALTER TABLE `cartapp_cartitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(13,'cartapp','cartitem'),(5,'contenttypes','contenttype'),(14,'goodsapp','category'),(15,'goodsapp','color'),(16,'goodsapp','comment'),(17,'goodsapp','gooddetail'),(18,'goodsapp','goods'),(19,'goodsapp','goodsdetailname'),(20,'goodsapp','inventory'),(21,'goodsapp','size'),(25,'goodsapp','usedgoods'),(26,'goodsapp','usedgoodsdetail'),(22,'orderapp','order'),(23,'orderapp','orderitem'),(6,'sessions','session'),(24,'shopapp','shop'),(11,'userapp','address'),(7,'userapp','area'),(10,'userapp','favoritegood'),(9,'userapp','followshop'),(12,'userapp','userfootprint'),(8,'userapp','userinfo');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-06-08 08:03:38.422390'),(2,'auth','0001_initial','2024-06-08 08:03:39.148086'),(3,'admin','0001_initial','2024-06-08 08:03:39.348668'),(4,'admin','0002_logentry_remove_auto_add','2024-06-08 08:03:39.360669'),(5,'admin','0003_logentry_add_action_flag_choices','2024-06-08 08:03:39.378846'),(6,'contenttypes','0002_remove_content_type_name','2024-06-08 08:03:39.500464'),(7,'auth','0002_alter_permission_name_max_length','2024-06-08 08:03:39.581506'),(8,'auth','0003_alter_user_email_max_length','2024-06-08 08:03:39.619502'),(9,'auth','0004_alter_user_username_opts','2024-06-08 08:03:39.632472'),(10,'auth','0005_alter_user_last_login_null','2024-06-08 08:03:39.709508'),(11,'auth','0006_require_contenttypes_0002','2024-06-08 08:03:39.713508'),(12,'auth','0007_alter_validators_add_error_messages','2024-06-08 08:03:39.724509'),(13,'auth','0008_alter_user_username_max_length','2024-06-08 08:03:39.810475'),(14,'auth','0009_alter_user_last_name_max_length','2024-06-08 08:03:39.892289'),(15,'auth','0010_alter_group_name_max_length','2024-06-08 08:03:39.923256'),(16,'auth','0011_update_proxy_permissions','2024-06-08 08:03:39.935219'),(17,'auth','0012_alter_user_first_name_max_length','2024-06-08 08:03:40.021420'),(18,'shopapp','0001_initial','2024-06-08 08:03:40.049426'),(19,'goodsapp','0001_initial','2024-06-08 08:03:40.270471'),(20,'userapp','0001_initial','2024-06-08 08:03:40.895925'),(21,'cartapp','0001_initial','2024-06-08 08:03:40.926943'),(22,'cartapp','0002_initial','2024-06-08 08:03:41.006925'),(23,'goodsapp','0002_initial','2024-06-08 08:03:41.737542'),(24,'orderapp','0001_initial','2024-06-08 08:03:41.787506'),(25,'orderapp','0002_initial','2024-06-08 08:03:42.041525'),(26,'sessions','0001_initial','2024-06-08 08:03:42.095106'),(27,'shopapp','0002_initial','2024-06-08 08:03:42.195066'),(28,'goodsapp','0003_alter_goods_oldprice_alter_goods_price_usedgoods_and_more','2024-06-08 08:16:59.122417'),(29,'goodsapp','0004_rename_name_usedgoods_gname','2024-06-08 08:37:24.800300'),(30,'goodsapp','0005_usedgoods_ifdelete','2024-06-09 04:22:29.723588'),(31,'goodsapp','0006_goods_isdelete','2024-06-09 04:42:07.504764'),(32,'goodsapp','0007_rename_desc_usedgoods_gdesc_and_more','2024-06-09 08:43:21.777343'),(33,'userapp','0002_alter_userinfo_balance','2024-06-09 08:55:10.415660'),(34,'goodsapp','0008_alter_goods_gname','2024-06-09 10:02:57.466206');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_category`
--

DROP TABLE IF EXISTS `goodsapp_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cname` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_category`
--

LOCK TABLES `goodsapp_category` WRITE;
/*!40000 ALTER TABLE `goodsapp_category` DISABLE KEYS */;
INSERT INTO `goodsapp_category` VALUES (1,'男装'),(2,'女装'),(3,'鞋子'),(4,'箱包'),(5,'美妆'),(6,'文体'),(7,'美食'),(8,'数码'),(9,'电器'),(10,'内衣'),(11,'装饰'),(12,'二手商品');
/*!40000 ALTER TABLE `goodsapp_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_color`
--

DROP TABLE IF EXISTS `goodsapp_color`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_color` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `colorname` varchar(10) NOT NULL,
  `colorurl` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_color`
--

LOCK TABLES `goodsapp_color` WRITE;
/*!40000 ALTER TABLE `goodsapp_color` DISABLE KEYS */;
INSERT INTO `goodsapp_color` VALUES (0,' ',' '),(1,'红色','/media/color/hong_Dm4fQ6U.jpg'),(2,'绿色','/media/color/lv_cTMJg2K.jpg'),(3,'黄色','/media/color/huang_bvCMlhn.jpg'),(4,'黑色','/media/color/hei_rFOWelp.jpg'),(5,'白色','/media/color/bai_mt1VrH5.jpg'),(6,'三号色','/media/color/san.jpg'),(7,'红色','/media/color/hong_y7wQwRw.jpg'),(8,'黄色','/media/color/huang_NKcgOlT.jpg'),(9,'紫色','/media/color/zi_umktLLD.jpg'),(10,'蓝色','/media/color/lan_BKQdpOj.jpg'),(11,'红色','/media/color/hong_zHPXVqY.jpg'),(12,'蓝色','/media/color/lan_IThSO4Z.jpg'),(13,'蓝色','/media/color/lan_ELubwxG.jpg'),(14,'绿色','/media/color/lv_H5hkmmq.jpg'),(15,'红色','/media/color/hong_4FhJTrJ.jpg'),(16,'蓝色','/media/color/lan_7rd4yDs.jpg'),(17,'灰色','/media/color/hui.jpg'),(18,'蓝色','/media/color/lan.jpg'),(19,'红色','/media/color/hong_UO2LzHh.jpg'),(20,'黑色','/media/color/hei_cOOnNKI.jpg'),(21,'黑色','/media/color/hei_kYyKPNv.jpg'),(22,'绿色','/media/color/lv_sxlJZTq.jpg'),(23,'白色','/media/color/bai_B7tmsjh.jpg'),(24,'黑色','/media/color/hei_sNOao2p.jpg'),(25,'橘色','/media/color/ju.jpg'),(26,'紫色','/media/color/zi.jpg'),(27,'斑马色','/media/color/ban_fSqFE03.jpg'),(28,'黑色','/media/color/hei_ZyxMfgc.jpg'),(29,'白色','/media/color/bai.jpg'),(30,'黑色','/media/color/hei_goVnbhs.jpg'),(31,'绿色','/media/color/lv_eFlravj.jpg'),(32,'红色','/media/color/hong_nwQGdMd.jpg'),(33,'棕色','/media/color/zong_v7JDaAc.jpg'),(34,'斑马色','/media/color/ban.jpg'),(35,'黑色','/media/color/hei_3vOTo3s.jpg'),(36,'绿色','/media/color/lv.jpg'),(37,'黄','/media/color/huang.jpg'),(38,'黑色','/media/color/hei_JeBWGjF.jpg'),(39,'黑色','/media/color/hei_LfSKcUV.jpg'),(40,'黑色','/media/color/hei_1d7yrVm.jpg'),(41,'黑色','/media/color/hei.jpg'),(42,'红色','/media/color/hongse.jpg'),(43,'黑色','/media/color/h_2og4uJv.jpg'),(44,'红色','/media/color/hong.jpg'),(45,'棕色','/media/color/zong.jpg'),(47,'黑色','/media/color/b_bmETiSP.jpg'),(48,'1','/media/color/bai_Kx041jA.jpg'),(49,'11','/media/color/UN(VK~DXHG$7(S)8U(HIGV9.jpg');
/*!40000 ALTER TABLE `goodsapp_color` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_comment`
--

DROP TABLE IF EXISTS `goodsapp_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` varchar(100) NOT NULL,
  `date` datetime(6) NOT NULL,
  `rating` int NOT NULL,
  `user_id` bigint NOT NULL,
  `goods_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodsapp_comment_user_id_2040e268_fk_userapp_userinfo_id` (`user_id`),
  KEY `goodsapp_comment_goods_id_f39805d1_fk_goodsapp_goods_id` (`goods_id`),
  CONSTRAINT `goodsapp_comment_goods_id_f39805d1_fk_goodsapp_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goodsapp_goods` (`id`),
  CONSTRAINT `goodsapp_comment_user_id_2040e268_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_comment`
--

LOCK TABLES `goodsapp_comment` WRITE;
/*!40000 ALTER TABLE `goodsapp_comment` DISABLE KEYS */;
INSERT INTO `goodsapp_comment` VALUES (1,'五星好评！','2024-06-09 12:36:00.029890',5,2,2);
/*!40000 ALTER TABLE `goodsapp_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_gooddetail`
--

DROP TABLE IF EXISTS `goodsapp_gooddetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_gooddetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `gdurl` varchar(100) NOT NULL,
  `goods_id` bigint NOT NULL,
  `goodsdname_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodsapp_gooddetail_goods_id_77ea24e8_fk_goodsapp_goods_id` (`goods_id`),
  KEY `goodsapp_gooddetail_goodsdname_id_7aed7a45_fk_goodsapp_` (`goodsdname_id`),
  CONSTRAINT `goodsapp_gooddetail_goods_id_77ea24e8_fk_goodsapp_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goodsapp_goods` (`id`),
  CONSTRAINT `goodsapp_gooddetail_goodsdname_id_7aed7a45_fk_goodsapp_` FOREIGN KEY (`goodsdname_id`) REFERENCES `goodsapp_goodsdetailname` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_gooddetail`
--

LOCK TABLES `goodsapp_gooddetail` WRITE;
/*!40000 ALTER TABLE `goodsapp_gooddetail` DISABLE KEYS */;
INSERT INTO `goodsapp_gooddetail` VALUES (1,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',1,1),(2,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',1,2),(3,'/media/1_mpwtoGA.jpg',1,3),(4,'/media/2_UuQkY4b.jpg',1,3),(5,'/media/3_ViMgWv6.jpg',1,3),(6,'/media/4_BDmgdFv.jpg',1,3),(7,'/media/5_ozWIsej.jpg',1,3),(8,'/media/6_Pny8yTQ.jpg',1,3),(9,'/media/7_K4tB09L.jpg',1,3),(10,'/media/8_60MJMwS.jpg',1,3),(11,'/media/9_8YomGSk.jpg',1,3),(12,'/media/10_vonnLjk.jpg',1,3),(13,'/static/images/B5_03.png',2,4),(14,'/static/images/B5_06.png',2,5),(15,'/media/1_DNiW0D5.jpg',2,6),(16,'/media/2_eHi0Rix.jpg',2,6),(17,'/media/3_2e1cWcs.jpg',2,6),(18,'/media/4_D0ck80V.jpg',2,6),(19,'/media/5_bxMyxv5.jpg',2,6),(20,'/media/6_Z4j72Ft.jpg',2,6),(21,'/media/7_3QbFC0z.jpg',2,6),(22,'/media/8_OQGcrwL.jpg',2,6),(23,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',3,7),(24,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',3,8),(25,'/media/1_QoLgPlj.jpg',3,9),(26,'/media/2_lHY8mE9.jpg',3,9),(27,'/media/3_GiFc4gk.jpg',3,9),(28,'/media/4_IBO3QkF.jpg',3,9),(29,'/media/5_NjssJjH.jpg',3,9),(30,'/media/6_TJDGChY.jpg',3,9),(31,'/media/7_Sv0tWHZ.jpg',3,9),(32,'/media/8_MDhSM1I.jpg',3,9),(33,'/media/9_BUoWkrL.jpg',3,9),(34,'/media/10_k9f1eEK.jpg',3,9),(35,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',4,10),(36,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',4,11),(37,'/media/1_ORTzeTY.jpg',4,12),(38,'/media/2_RbgTYId.jpg',4,12),(39,'/media/3_1CyOSyR.jpg',4,12),(40,'/media/4_0490Pq4.jpg',4,12),(41,'/media/5_gk51Yc1.jpg',4,12),(42,'/media/6_MNo76Wb.jpg',4,12),(43,'/media/7_4JyLPNO.jpg',4,12),(44,'/media/8_VX32aT2.jpg',4,12),(45,'/media/9_x8mkplo.jpg',4,12),(46,'/media/10_1OVaH2E.jpg',4,12),(47,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',5,13),(48,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',5,14),(49,'/media/1_0IilSTS.jpg',5,15),(50,'/media/2_dU6RLKQ.jpg',5,15),(51,'/media/3_eLYKeSJ.jpg',5,15),(52,'/media/4_mwUqQ7u.jpg',5,15),(53,'/media/5_AOfqMfX.jpg',5,15),(54,'/media/6_LE1Qg19.jpg',5,15),(55,'/media/7_7RVZFif.jpg',5,15),(56,'/media/8_W5zUBfp.jpg',5,15),(57,'/media/9_Py3cDKv.jpg',5,15),(58,'/media/10_w9OXfoC.jpg',5,15),(59,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',6,16),(60,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',6,17),(61,'/media/1_f8GP2Js.jpg',6,18),(62,'/media/2_mewqiym.jpg',6,18),(63,'/media/3_T3najRK.jpg',6,18),(64,'/media/4_Zn7OFjf.jpg',6,18),(65,'/media/5_z6JRqPe.jpg',6,18),(66,'/media/6_96JhJlq.jpg',6,18),(67,'/media/7_eNtOUP3.jpg',6,18),(68,'/media/8_B13UoeN.jpg',6,18),(69,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',7,19),(70,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',7,20),(71,'/media/1_bmqDR3N.jpg',7,21),(72,'/media/2_72CrUqv.jpg',7,21),(73,'/media/3_FVVk5kE.jpg',7,21),(74,'/media/4_LNKrlRN.jpg',7,21),(75,'/media/5_qHsL809.jpg',7,21),(76,'/media/6_EXgGQLK.jpg',7,21),(77,'/media/7_lJD2O84.jpg',7,21),(78,'/media/8_TM4De6X.jpg',7,21),(79,'/media/9_gLF6TGo.jpg',7,21),(80,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',8,22),(81,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',8,23),(82,'/media/1_VJ7ZAQ6.jpg',8,24),(83,'/media/2_w4cxzhY.jpg',8,24),(84,'/media/3_U55lgsP.jpg',8,24),(85,'/media/4_EzoxL21.jpg',8,24),(86,'/media/5_Rewgb01.jpg',8,24),(87,'/media/6_ze76f9K.jpg',8,24),(88,'/media/7_6Wq1Bgx.jpg',8,24),(89,'/media/8_R2uMfUz.jpg',8,24),(90,'/media/9_D7uVd9z.jpg',8,24),(91,'/media/10_0RIywDD.jpg',8,24),(92,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',9,25),(93,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',9,26),(94,'/media/1_mfc1bTY.jpg',9,27),(95,'/media/2_GohidDO.jpg',9,27),(96,'/media/3_mFj1A5X.jpg',9,27),(97,'/media/4_H23ayWL.jpg',9,27),(98,'/media/5_SGzSxZZ.jpg',9,27),(99,'/media/6_li3hJqN.jpg',9,27),(100,'/media/7_lK1M9SF.jpg',9,27),(101,'/media/8_7L4e40W.jpg',9,27),(102,'/media/9_TW7TlmY.jpg',9,27),(103,'/media/10_woLP7jo.jpg',9,27),(104,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',10,28),(105,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',10,29),(106,'/media/1_oeshNKk.jpg',10,30),(107,'/media/2_iQ7dNj1.jpg',10,30),(108,'/media/3_8WGGwE5.jpg',10,30),(109,'/media/4_m2QcMFM.jpg',10,30),(110,'/media/5_m3BYUyr.jpg',10,30),(111,'/media/6_mJhhcKP.jpg',10,30),(112,'/media/7_NKEyR9K.jpg',10,30),(113,'/media/8_gRR4RHz.jpg',10,30),(114,'/media/9_YhUmuWF.jpg',10,30),(115,'/media/10_8H4hKoc.jpg',10,30),(116,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',11,31),(117,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',11,32),(118,'/media/1_Rqdz7U7.jpg',11,33),(119,'/media/2_wyGJ4ta.jpg',11,33),(120,'/media/3_NNxcobt.jpg',11,33),(121,'/media/4_LOhSXlh.jpg',11,33),(122,'/media/5_OEepnkc.jpg',11,33),(123,'/media/6_om0yrNS.jpg',11,33),(124,'/media/7_va0yr9Y.jpg',11,33),(125,'/media/8_egWx7Pl.jpg',11,33),(126,'/media/9_JJPOi3d.jpg',11,33),(127,'/media/10_yXoBnL0.jpg',11,33),(128,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',12,34),(129,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',12,35),(130,'/media/1_EPbLlsh.jpg',12,36),(131,'/media/2_CG1HTi2.jpg',12,36),(132,'/media/3_LrJ1TCJ.jpg',12,36),(133,'/media/4_ppO44fs.jpg',12,36),(134,'/media/5_3tIgCS6.jpg',12,36),(135,'/media/6_KN6SOts.jpg',12,36),(136,'/media/7_7vLJg1T.jpg',12,36),(137,'/media/8_BaXff43.jpg',12,36),(138,'/media/9_AexcCbE.jpg',12,36),(139,'/media/10_yG5bZ6x.jpg',12,36),(140,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',13,37),(141,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',13,38),(142,'/media/1_X1vUHuX.jpg',13,39),(143,'/media/2_rQvH5hc.jpg',13,39),(144,'/media/3_T5aiJXo.jpg',13,39),(145,'/media/4_VYfCSBP.jpg',13,39),(146,'/media/5_KdbwcPL.jpg',13,39),(147,'/media/6_7stuZRI.jpg',13,39),(148,'/media/7_WB2mznP.jpg',13,39),(149,'/media/8_7HnFJUe.jpg',13,39),(150,'/media/9_HN634xt.jpg',13,39),(151,'/media/10_Gs7AS8Z.jpg',13,39),(152,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',14,40),(153,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',14,41),(154,'/media/1_qhSeLSP.jpg',14,42),(155,'/media/2_T1EYNmq.jpg',14,42),(156,'/media/3_M5MK3Rp.jpg',14,42),(157,'/media/4_Qsb0wFi.jpg',14,42),(158,'/media/5_8L7yPar.jpg',14,42),(159,'/media/6_Xaip1y1.jpg',14,42),(160,'/media/7_MEUf1z0.jpg',14,42),(161,'/media/8_KtL5Rj0.jpg',14,42),(162,'/media/9_yFn3P2g.jpg',14,42),(163,'/media/10_TmP9DXa.jpg',14,42),(164,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',15,43),(165,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',15,44),(166,'/media/1_YVRqAfG.jpg',15,45),(167,'/media/2_rJP2AdH.jpg',15,45),(168,'/media/3_gQdONuG.jpg',15,45),(169,'/media/4_7T0yj4F.jpg',15,45),(170,'/media/5_DI2p1Wl.jpg',15,45),(171,'/media/6_CmqXZLW.jpg',15,45),(172,'/media/7_XOIrJSq.jpg',15,45),(173,'/media/8_ZqFUlsq.jpg',15,45),(174,'/media/9_CwxVXnR.jpg',15,45),(175,'/media/10_gn66t3j.jpg',15,45),(176,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',16,46),(177,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',16,47),(178,'/media/1_v57UFo5.jpg',16,48),(179,'/media/2_nT3X3Gi.jpg',16,48),(180,'/media/3_C9361FH.jpg',16,48),(181,'/media/4_KPjviHC.jpg',16,48),(182,'/media/5_j9H6NUg.jpg',16,48),(183,'/media/6_0yvtHsK.jpg',16,48),(184,'/media/7_OyIqVRu.jpg',16,48),(185,'/media/8_zaePCtI.jpg',16,48),(186,'/media/9_zDqfKRE.jpg',16,48),(187,'/media/10_o3nc5fU.jpg',16,48),(188,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',17,49),(189,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',17,50),(190,'/media/1_vXCGxCI.jpg',17,51),(191,'/media/2_54gKgQP.jpg',17,51),(192,'/media/3_eNxYhCr.jpg',17,51),(193,'/media/4_BprQkfJ.jpg',17,51),(194,'/media/5_qsc95lP.jpg',17,51),(195,'/media/6_UAGLwbX.jpg',17,51),(196,'/media/7_F6hIwWB.jpg',17,51),(197,'/media/8_a2kJabS.jpg',17,51),(198,'/media/9_SZ0wMpy.jpg',17,51),(199,'/media/10_MeWXSKs.jpg',17,51),(200,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',18,52),(201,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',18,53),(202,'/media/1_NMUUNXC.jpg',18,54),(203,'/media/2_Ouot4Pr.jpg',18,54),(204,'/media/3_Gz1jfea.jpg',18,54),(205,'/media/4_I75CkJ3.jpg',18,54),(206,'/media/5_o83wrz9.jpg',18,54),(207,'/media/6_a6urQrM.jpg',18,54),(208,'/media/7_Wj7Dhuj.jpg',18,54),(209,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',19,55),(210,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',19,56),(211,'/media/1_hYKWHNU.jpg',19,57),(212,'/media/2_HG8qNBO.jpg',19,57),(213,'/media/3_aDwC2Ql.jpg',19,57),(214,'/media/4_Rj4l1L8.jpg',19,57),(215,'/media/5_23MIkpl.jpg',19,57),(216,'/media/6_q3Kpy4T.jpg',19,57),(217,'/media/7_9VDJMAo.jpg',19,57),(218,'/media/8_aIKJvFt.jpg',19,57),(219,'/media/9_InpWyDb.jpg',19,57),(220,'/media/10_5jDjWzb.jpg',19,57),(221,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',20,58),(222,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',20,59),(223,'/media/1_elE8eIp.jpg',20,60),(224,'/media/2_4vn9XVx.jpg',20,60),(225,'/media/3_D1iL18X.jpg',20,60),(226,'/media/4_i3s0HY6.jpg',20,60),(227,'/media/5_fjAcCOl.jpg',20,60),(228,'/media/6_ECsXNEg.jpg',20,60),(229,'/media/7_7pnv5eG.jpg',20,60),(230,'/media/8_dDvDZt3.jpg',20,60),(231,'/media/9_e0PyyUN.jpg',20,60),(232,'/media/10_w27K7NE.jpg',20,60),(233,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',21,61),(234,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',21,62),(235,'/media/1_lCofK1Q.jpg',21,63),(236,'/media/2_fN7fXqT.jpg',21,63),(237,'/media/3_sQci5N1.jpg',21,63),(238,'/media/4_t8f1jLp.jpg',21,63),(239,'/media/5_pnAqZij.jpg',21,63),(240,'/media/6_Jyvt0gV.jpg',21,63),(241,'/media/7_88GAaTo.jpg',21,63),(242,'/media/8_dwmGQq1.jpg',21,63),(243,'/media/9_IVxniTc.jpg',21,63),(244,'/media/10_MBQOH1D.jpg',21,63),(245,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_03.png',22,64),(246,'/static/img/%E8%AF%A6%E6%83%85%E9%A1%B5_06.png',22,65),(247,'/media/1.jpg',22,66),(248,'/media/2.jpg',22,66),(249,'/media/3.jpg',22,66),(250,'/media/4.jpg',22,66),(251,'/media/5.jpg',22,66),(252,'/media/6.jpg',22,66),(253,'/media/7.jpg',22,66),(254,'/media/8.jpg',22,66),(255,'/media/9.jpg',22,66),(256,'/media/10.jpg',22,66),(257,'/media/bai.jpg',23,67),(258,'/media/bai_mt1VrH5.jpg',23,68),(259,'/media/h_2og4uJv.jpg',24,69),(260,'/media/UN(VK~DXHG$7(S)8U(HIGV9_8bCjBp6.jpg',25,70);
/*!40000 ALTER TABLE `goodsapp_gooddetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_goods`
--

DROP TABLE IF EXISTS `goodsapp_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `gname` varchar(100) NOT NULL,
  `gdesc` varchar(100) NOT NULL,
  `oldprice` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `isHot` tinyint(1) NOT NULL,
  `category_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `isdelete` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodsapp_goods_category_id_0b10ff8f_fk_goodsapp_category_id` (`category_id`),
  KEY `goodsapp_goods_shop_id_5e0d9184_fk_shopapp_shop_id` (`shop_id`),
  CONSTRAINT `goodsapp_goods_category_id_0b10ff8f_fk_goodsapp_category_id` FOREIGN KEY (`category_id`) REFERENCES `goodsapp_category` (`id`),
  CONSTRAINT `goodsapp_goods_shop_id_5e0d9184_fk_shopapp_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `shopapp_shop` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_goods`
--

LOCK TABLES `goodsapp_goods` WRITE;
/*!40000 ALTER TABLE `goodsapp_goods` DISABLE KEYS */;
INSERT INTO `goodsapp_goods` VALUES (1,'测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长测试长度','测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度',5.56,1000000.00,0,2,1,1),(2,'秋时尚印花两件套装裙','秋装时尚印花复古时尚休闲两件套装裙子',100.00,35.00,1,2,1,0),(3,'韩版侧开叉宽松毛衣','新款韩版前短后长 侧开叉宽松圆领 纯色大码套头针织衫外套',369.00,39.00,0,2,1,0),(4,'无袖套头毛衣马甲女秋','2017秋季新款上衣潮 笑脸学院风针织背心无袖套头毛衣马甲女春秋',296.00,39.00,0,2,1,0),(5,'红色原宿bf风小外套','诗赫姿秋新款红色原宿bf风牛仔小外套女',229.00,69.00,0,2,1,0),(6,'不规则毛边喇叭牛仔裤','诗赫姿秋新款不规则毛边喇叭长裤牛仔裤',199.00,65.00,0,2,1,0),(7,'宽松短款牛仔外套','诗赫姿秋新款宽松短款时尚绣花牛仔外套女',259.00,79.00,0,2,1,0),(8,'气质收腰显瘦连衣裙','诗赫姿秋新款气质时尚收腰显瘦连衣裙女',199.00,69.00,0,2,1,0),(9,'针织袖拼接毛呢打底裙','诗赫姿秋新款针织袖时尚拼接毛呢打底裙',199.00,69.00,0,2,1,0),(10,'双排扣假两件连衣裙','诗赫姿秋新款简约双排扣假两件连衣裙女',299.00,69.00,0,2,1,0),(11,'修身包臀蕾丝打底裙','诗赫姿秋新款修身包臀蕾丝打底裙连衣裙',199.00,69.00,0,2,1,0),(12,'修身显瘦格子打底裙','诗赫姿秋新款修身显瘦格子打底裙连衣裙',259.00,69.90,0,2,1,0),(13,'条纹显瘦网纱连衣裙','诗赫姿秋新款条纹时尚显瘦网纱连衣裙女',199.00,69.90,0,2,1,0),(14,'显瘦蕾丝中长连衣裙','诗赫姿秋新款时尚显瘦蕾丝中长连衣裙女',255.00,69.00,0,2,1,0),(15,'时尚修身两件套装裙','诗赫姿秋新款时尚修身两件套装连衣裙女',299.00,68.90,0,2,1,0),(16,'条纹针织包臀连衣裙','诗赫姿秋条纹时尚针织包臀打底裙连衣裙',199.00,65.00,0,2,1,0),(17,'系带显瘦宽松套装','诗赫姿秋系带显瘦宽松时尚套装阔腿裤女',259.00,69.90,0,2,1,0),(18,'秋季V领镂空蕾丝衫','新款大码女装蕾丝衫韩版修身V领长袖打底衫网纱镂空上衣',124.00,28.00,0,2,1,0),(19,'松紧腰PU皮短裤','秋冬时尚百搭高腰PU皮阔腿短裤女打底皮裤',199.00,19.90,0,2,1,0),(20,'高腰刺绣PU皮短裙','秋冬时尚高腰刺绣PU皮短裙女打底半身裙',199.00,29.90,0,2,1,0),(21,'修身短款呢子小外套','秋装新款女装毛呢短外套女 时尚修身短款呢子小西装潮',199.00,39.00,0,2,1,0),(22,'中长款双面呢毛呢外套','中长款双面呢毛呢外套',256.00,33.00,0,2,1,0),(23,'测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长2测试长度','测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度12',-1.00,100.00,0,1,1,0),(24,'一条裙子','一条白裙子',1.00,99.00,0,1,1,0),(25,'123','1111',12.00,1.00,0,1,1,1);
/*!40000 ALTER TABLE `goodsapp_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_goodsdetailname`
--

DROP TABLE IF EXISTS `goodsapp_goodsdetailname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_goodsdetailname` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `gdname` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_goodsdetailname`
--

LOCK TABLES `goodsapp_goodsdetailname` WRITE;
/*!40000 ALTER TABLE `goodsapp_goodsdetailname` DISABLE KEYS */;
INSERT INTO `goodsapp_goodsdetailname` VALUES (1,'参数规格'),(2,'整体款式'),(3,'模特实拍'),(4,'参数规格'),(5,'整体款式'),(6,'模特实拍'),(7,'参数规格'),(8,'整体款式'),(9,'模特实拍'),(10,'参数规格'),(11,'整体款式'),(12,'模特实拍'),(13,'参数规格'),(14,'整体款式'),(15,'模特实拍'),(16,'参数规格'),(17,'整体款式'),(18,'模特实拍'),(19,'参数规格'),(20,'整体款式'),(21,'模特实拍'),(22,'参数规格'),(23,'整体款式'),(24,'模特实拍'),(25,'参数规格'),(26,'整体款式'),(27,'模特实拍'),(28,'参数规格'),(29,'整体款式'),(30,'模特实拍'),(31,'参数规格'),(32,'整体款式'),(33,'模特实拍'),(34,'参数规格'),(35,'整体款式'),(36,'模特实拍'),(37,'参数规格'),(38,'整体款式'),(39,'模特实拍'),(40,'参数规格'),(41,'整体款式'),(42,'模特实拍'),(43,'参数规格'),(44,'整体款式'),(45,'模特实拍'),(46,'参数规格'),(47,'整体款式'),(48,'模特实拍'),(49,'参数规格'),(50,'整体款式'),(51,'模特实拍'),(52,'参数规格'),(53,'整体款式'),(54,'模特实拍'),(55,'参数规格'),(56,'整体款式'),(57,'模特实拍'),(58,'参数规格'),(59,'整体款式'),(60,'模特实拍'),(61,'参数规格'),(62,'整体款式'),(63,'模特实拍'),(64,'参数规格'),(65,'整体款式'),(66,'模特实拍'),(67,'详情1'),(68,'详情2'),(69,'1'),(70,'123');
/*!40000 ALTER TABLE `goodsapp_goodsdetailname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_inventory`
--

DROP TABLE IF EXISTS `goodsapp_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `count` int unsigned NOT NULL,
  `color_id` bigint NOT NULL,
  `goods_id` bigint NOT NULL,
  `size_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodsapp_inventory_color_id_7ae989f2_fk_goodsapp_color_id` (`color_id`),
  KEY `goodsapp_inventory_goods_id_1ad37f5d_fk_goodsapp_goods_id` (`goods_id`),
  KEY `goodsapp_inventory_size_id_916857fc_fk_goodsapp_size_id` (`size_id`),
  CONSTRAINT `goodsapp_inventory_color_id_7ae989f2_fk_goodsapp_color_id` FOREIGN KEY (`color_id`) REFERENCES `goodsapp_color` (`id`),
  CONSTRAINT `goodsapp_inventory_goods_id_1ad37f5d_fk_goodsapp_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goodsapp_goods` (`id`),
  CONSTRAINT `goodsapp_inventory_size_id_916857fc_fk_goodsapp_size_id` FOREIGN KEY (`size_id`) REFERENCES `goodsapp_size` (`id`),
  CONSTRAINT `goodsapp_inventory_chk_1` CHECK ((`count` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_inventory`
--

LOCK TABLES `goodsapp_inventory` WRITE;
/*!40000 ALTER TABLE `goodsapp_inventory` DISABLE KEYS */;
INSERT INTO `goodsapp_inventory` VALUES (1,0,1,1,1),(2,0,1,1,2),(3,0,1,1,3),(4,0,1,1,4),(5,0,2,1,1),(6,0,2,1,2),(7,0,2,1,3),(8,0,2,1,4),(9,0,3,1,1),(10,0,3,1,2),(11,0,3,1,3),(12,0,3,1,4),(13,0,4,1,1),(14,0,4,1,2),(15,0,4,1,3),(16,0,4,1,4),(17,100,5,2,5),(18,97,5,2,6),(19,100,5,2,7),(20,100,5,2,8),(21,100,6,2,5),(22,100,6,2,6),(23,100,6,2,7),(24,100,6,2,8),(25,100,7,3,9),(26,100,8,3,9),(27,100,9,3,9),(28,100,10,4,6),(29,100,11,5,5),(30,100,11,5,6),(31,100,11,5,7),(32,100,11,5,8),(33,100,12,6,5),(34,100,12,6,6),(35,100,12,6,7),(36,100,13,7,6),(37,100,13,7,7),(38,100,13,7,8),(39,100,14,8,5),(40,100,14,8,6),(41,100,14,8,7),(42,100,14,8,8),(43,100,15,8,5),(44,100,15,8,6),(45,100,15,8,7),(46,100,15,8,8),(47,100,16,8,5),(48,100,16,8,6),(49,100,16,8,7),(50,100,16,8,8),(51,100,17,9,5),(52,100,17,9,6),(53,100,17,9,7),(54,100,17,9,8),(55,100,18,9,5),(56,100,18,9,6),(57,100,18,9,7),(58,100,18,9,8),(59,100,19,9,5),(60,100,19,9,6),(61,100,19,9,7),(62,100,19,9,8),(63,100,20,9,5),(64,100,20,9,6),(65,100,20,9,7),(66,100,20,9,8),(67,100,21,10,5),(68,100,21,10,6),(69,100,21,10,7),(70,100,21,10,8),(71,100,22,11,5),(72,100,22,11,6),(73,100,22,11,7),(74,100,22,11,8),(75,100,23,11,5),(76,100,23,11,6),(77,100,23,11,7),(78,100,23,11,8),(79,100,24,11,5),(80,100,24,11,6),(81,100,24,11,7),(82,100,24,11,8),(83,100,25,12,6),(84,100,25,12,7),(85,100,25,12,8),(86,100,26,12,6),(87,100,26,12,7),(88,100,26,12,8),(89,100,27,13,5),(90,100,27,13,6),(91,100,27,13,7),(92,100,27,13,8),(93,100,28,13,5),(94,100,28,13,6),(95,100,28,13,7),(96,100,28,13,8),(97,100,29,14,5),(98,100,29,14,6),(99,100,29,14,7),(100,100,29,14,8),(101,100,30,14,5),(102,100,30,14,6),(103,100,30,14,7),(104,100,30,14,8),(105,100,31,15,5),(106,100,31,15,6),(107,100,31,15,7),(108,100,31,15,8),(109,100,32,15,5),(110,100,32,15,6),(111,100,32,15,7),(112,100,32,15,8),(113,100,33,15,5),(114,100,33,15,6),(115,100,33,15,7),(116,100,33,15,8),(117,100,34,16,6),(118,100,34,16,7),(119,100,34,16,8),(120,100,35,17,5),(121,100,35,17,6),(122,100,35,17,7),(123,100,35,17,8),(124,100,36,17,5),(125,100,36,17,6),(126,100,36,17,7),(127,100,36,17,8),(128,100,37,17,5),(129,100,37,17,6),(130,100,37,17,7),(131,100,37,17,8),(132,100,38,18,5),(133,100,38,18,6),(134,100,38,18,7),(135,100,39,19,5),(136,100,39,19,6),(137,100,39,19,7),(138,100,39,19,8),(139,100,40,20,5),(140,100,40,20,6),(141,100,40,20,7),(142,100,40,20,8),(143,100,41,21,5),(144,100,41,21,6),(145,100,41,21,7),(146,100,41,21,8),(147,100,42,21,5),(148,100,42,21,6),(149,100,42,21,7),(150,100,42,21,8),(151,100,43,22,5),(152,100,43,22,6),(153,100,43,22,7),(154,100,43,22,8),(155,100,44,22,5),(156,100,44,22,6),(157,100,44,22,7),(158,100,44,22,8),(159,100,45,22,5),(160,100,45,22,6),(161,100,45,22,7),(162,100,45,22,8),(163,0,47,23,11),(164,0,47,23,12),(165,0,47,23,13),(166,0,47,23,14),(167,0,47,23,15),(168,999990,48,24,16),(169,0,49,25,17),(170,0,49,25,18);
/*!40000 ALTER TABLE `goodsapp_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_size`
--

DROP TABLE IF EXISTS `goodsapp_size`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_size` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sname` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_size`
--

LOCK TABLES `goodsapp_size` WRITE;
/*!40000 ALTER TABLE `goodsapp_size` DISABLE KEYS */;
INSERT INTO `goodsapp_size` VALUES (0,' '),(1,'150'),(2,'160'),(3,'165'),(4,'170'),(5,'S'),(6,'M'),(7,'L'),(8,'XL'),(9,'均码'),(11,'1'),(12,'2'),(13,'3'),(14,'四'),(15,'5'),(16,'1'),(17,'1'),(18,'2');
/*!40000 ALTER TABLE `goodsapp_size` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_usedgoods`
--

DROP TABLE IF EXISTS `goodsapp_usedgoods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_usedgoods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `gname` varchar(100) NOT NULL,
  `gdesc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `isdelete` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`gname`),
  KEY `goodsapp_usedgoods_category_id_7264b1a2_fk_goodsapp_category_id` (`category_id`),
  KEY `goodsapp_usedgoods_user_id_ad506f42_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `goodsapp_usedgoods_category_id_7264b1a2_fk_goodsapp_category_id` FOREIGN KEY (`category_id`) REFERENCES `goodsapp_category` (`id`),
  CONSTRAINT `goodsapp_usedgoods_user_id_ad506f42_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_usedgoods`
--

LOCK TABLES `goodsapp_usedgoods` WRITE;
/*!40000 ALTER TABLE `goodsapp_usedgoods` DISABLE KEYS */;
INSERT INTO `goodsapp_usedgoods` VALUES (2,'鸡你太美','114',114.00,12,2,1),(3,'我测你们码','测测测测测测测测测测测测测测测测测',233.00,12,2,1),(4,'一张图片','这是一张好看的图片',100.00,12,2,0);
/*!40000 ALTER TABLE `goodsapp_usedgoods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsapp_usedgoodsdetail`
--

DROP TABLE IF EXISTS `goodsapp_usedgoodsdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodsapp_usedgoodsdetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ugdurl` varchar(100) NOT NULL,
  `ugdname` varchar(30) NOT NULL,
  `usedgoods_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodsapp_usedgoodsde_usedgoods_id_0e808649_fk_goodsapp_` (`usedgoods_id`),
  CONSTRAINT `goodsapp_usedgoodsde_usedgoods_id_0e808649_fk_goodsapp_` FOREIGN KEY (`usedgoods_id`) REFERENCES `goodsapp_usedgoods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsapp_usedgoodsdetail`
--

LOCK TABLES `goodsapp_usedgoodsdetail` WRITE;
/*!40000 ALTER TABLE `goodsapp_usedgoodsdetail` DISABLE KEYS */;
INSERT INTO `goodsapp_usedgoodsdetail` VALUES (3,'/media/UN(VK~DXHG$7(S)8U(HIGV9_KI8fsre.jpg','1',2),(4,'/media/UN(VK~DXHG$7(S)8U(HIGV9_w3PInOf.jpg','2',2),(5,'/media/R1NJ9C{~H95[D%{4XAR(~SV.png','1',3),(6,'/media/UN(VK~DXHG$7(S)8U(HIGV9_ePxQ96E.jpg','2',3),(7,'/media/UN(VK~DXHG$7(S)8U(HIGV9_0nYqTtn.jpg','1',4),(8,'/media/UN(VK~DXHG$7(S)8U(HIGV9_eOEWJeq.jpg','2',4);
/*!40000 ALTER TABLE `goodsapp_usedgoodsdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderapp_order`
--

DROP TABLE IF EXISTS `orderapp_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderapp_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_num` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL,
  `payway` varchar(20) NOT NULL,
  `totalPrice` decimal(10,2) NOT NULL,
  `address_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orderapp_order_address_id_a833e111_fk_userapp_address_id` (`address_id`),
  KEY `orderapp_order_user_id_a86cb24c_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `orderapp_order_address_id_a833e111_fk_userapp_address_id` FOREIGN KEY (`address_id`) REFERENCES `userapp_address` (`id`),
  CONSTRAINT `orderapp_order_user_id_a86cb24c_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderapp_order`
--

LOCK TABLES `orderapp_order` WRITE;
/*!40000 ALTER TABLE `orderapp_order` DISABLE KEYS */;
INSERT INTO `orderapp_order` VALUES (32,'20240609122738791070','已支付','walletpay',114.00,3,1,'2024-06-09 04:27:38.791070'),(33,'20240609125305807359','已支付','walletpay',114.00,3,1,'2024-06-09 04:53:05.808343'),(35,'20240609133225706210','已支付','walletpay',233.00,3,1,'2024-06-09 05:32:25.707214'),(36,'20240609154912712363','未生成','walletpay',11400.00,3,1,'2024-06-09 07:49:12.713383'),(43,'20240609164403665209','未支付','walletpay',10000000.00,3,1,'2024-06-09 08:44:03.665209'),(44,'20240609164511899006','已支付','walletpay',100000.00,3,1,'2024-06-09 08:45:11.899006'),(45,'20240609165156719239','已支付','walletpay',100000.00,3,1,'2024-06-09 08:51:56.720241'),(46,'20240609165225828536','未支付','walletpay',100000.00,3,1,'2024-06-09 08:52:25.828536'),(50,'20240609203141409699','未生成','walletpay',3535.00,3,1,'2024-06-09 12:31:41.409699'),(51,'20240609210105554603','已支付','walletpay',105.00,4,2,'2024-06-09 13:01:05.554603');
/*!40000 ALTER TABLE `orderapp_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderapp_orderitem`
--

DROP TABLE IF EXISTS `orderapp_orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderapp_orderitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goodsid` int unsigned NOT NULL,
  `colorid` int unsigned NOT NULL,
  `sizeid` int unsigned NOT NULL,
  `count` int unsigned NOT NULL,
  `order_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orderapp_orderitem_order_id_c57e4076_fk_orderapp_order_id` (`order_id`),
  CONSTRAINT `orderapp_orderitem_order_id_c57e4076_fk_orderapp_order_id` FOREIGN KEY (`order_id`) REFERENCES `orderapp_order` (`id`),
  CONSTRAINT `orderapp_orderitem_chk_1` CHECK ((`goodsid` >= 0)),
  CONSTRAINT `orderapp_orderitem_chk_2` CHECK ((`colorid` >= 0)),
  CONSTRAINT `orderapp_orderitem_chk_3` CHECK ((`sizeid` >= 0)),
  CONSTRAINT `orderapp_orderitem_chk_4` CHECK ((`count` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderapp_orderitem`
--

LOCK TABLES `orderapp_orderitem` WRITE;
/*!40000 ALTER TABLE `orderapp_orderitem` DISABLE KEYS */;
INSERT INTO `orderapp_orderitem` VALUES (32,2,0,0,1,32),(33,2,0,0,1,33),(35,3,0,0,1,35),(36,1,1,1,100,36),(43,4,0,0,1,43),(44,4,0,0,1,44),(45,4,0,0,1,45),(46,4,0,0,1,46),(50,2,6,6,101,50),(51,2,5,6,3,51);
/*!40000 ALTER TABLE `orderapp_orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopapp_shop`
--

DROP TABLE IF EXISTS `shopapp_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopapp_shop` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sname` varchar(50) NOT NULL,
  `fan_num` int NOT NULL,
  `rating` decimal(3,2) NOT NULL,
  `slogourl` varchar(100) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shopapp_shop_user_id_0fdddda2_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `shopapp_shop_user_id_0fdddda2_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopapp_shop`
--

LOCK TABLES `shopapp_shop` WRITE;
/*!40000 ALTER TABLE `shopapp_shop` DISABLE KEYS */;
INSERT INTO `shopapp_shop` VALUES (1,'AAA淘多多官方旗舰店',1,3.00,'/static/images/shop_logo.png',1),(2,'淘多多旗舰店二号',1,3.00,'/static/images/shop_logo.png',1),(3,'淘多多旗舰店分店',1,3.00,'/media/shop_logo/UN(VK~DXHG$7(S)8U(HIGV9.jpg',1);
/*!40000 ALTER TABLE `shopapp_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userapp_address`
--

DROP TABLE IF EXISTS `userapp_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userapp_address` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `aname` varchar(30) NOT NULL,
  `aphone` varchar(11) NOT NULL,
  `addr` varchar(100) NOT NULL,
  `isdefault` tinyint(1) NOT NULL,
  `userinfo_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userapp_address_userinfo_id_71e64d94_fk_userapp_userinfo_id` (`userinfo_id`),
  CONSTRAINT `userapp_address_userinfo_id_71e64d94_fk_userapp_userinfo_id` FOREIGN KEY (`userinfo_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userapp_address`
--

LOCK TABLES `userapp_address` WRITE;
/*!40000 ALTER TABLE `userapp_address` DISABLE KEYS */;
INSERT INTO `userapp_address` VALUES (3,'牢大Kobe','13464587956','落山机糊人aaaaaa啊啊啊',1,1),(4,'淘多多用户','13400000001','北京航空航天大学学院路校区新北区15公寓',1,2),(5,'淘多多用户','13400000001','北京航空航天大学学院路校区新北区菜鸟驿站',0,2);
/*!40000 ALTER TABLE `userapp_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userapp_favoritegood`
--

DROP TABLE IF EXISTS `userapp_favoritegood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userapp_favoritegood` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `good_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userapp_favoritegood_good_id_723501be_fk_goodsapp_goods_id` (`good_id`),
  KEY `userapp_favoritegood_user_id_07cea4be_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `userapp_favoritegood_good_id_723501be_fk_goodsapp_goods_id` FOREIGN KEY (`good_id`) REFERENCES `goodsapp_goods` (`id`),
  CONSTRAINT `userapp_favoritegood_user_id_07cea4be_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userapp_favoritegood`
--

LOCK TABLES `userapp_favoritegood` WRITE;
/*!40000 ALTER TABLE `userapp_favoritegood` DISABLE KEYS */;
INSERT INTO `userapp_favoritegood` VALUES (1,1,1);
/*!40000 ALTER TABLE `userapp_favoritegood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userapp_followshop`
--

DROP TABLE IF EXISTS `userapp_followshop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userapp_followshop` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userapp_followshop_shop_id_45395a59_fk_shopapp_shop_id` (`shop_id`),
  KEY `userapp_followshop_user_id_b4ab698c_fk_userapp_userinfo_id` (`user_id`),
  CONSTRAINT `userapp_followshop_shop_id_45395a59_fk_shopapp_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `shopapp_shop` (`id`),
  CONSTRAINT `userapp_followshop_user_id_b4ab698c_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userapp_followshop`
--

LOCK TABLES `userapp_followshop` WRITE;
/*!40000 ALTER TABLE `userapp_followshop` DISABLE KEYS */;
/*!40000 ALTER TABLE `userapp_followshop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userapp_userfootprint`
--

DROP TABLE IF EXISTS `userapp_userfootprint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userapp_userfootprint` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) NOT NULL,
  `goods_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userapp_userfootprint_user_id_goods_id_fe08b58a_uniq` (`user_id`,`goods_id`),
  KEY `userapp_userfootprint_goods_id_67290f0a_fk_goodsapp_goods_id` (`goods_id`),
  CONSTRAINT `userapp_userfootprint_goods_id_67290f0a_fk_goodsapp_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goodsapp_goods` (`id`),
  CONSTRAINT `userapp_userfootprint_user_id_d2469600_fk_userapp_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `userapp_userinfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userapp_userfootprint`
--

LOCK TABLES `userapp_userfootprint` WRITE;
/*!40000 ALTER TABLE `userapp_userfootprint` DISABLE KEYS */;
INSERT INTO `userapp_userfootprint` VALUES (1,'2024-06-09 10:22:13.324261',1,1),(2,'2024-06-09 10:26:24.274214',1,2),(3,'2024-06-09 13:01:02.424691',2,2),(4,'2024-06-09 14:45:52.346865',2,1),(5,'2024-06-09 10:27:27.023826',23,1),(6,'2024-06-09 10:15:21.166735',24,2),(7,'2024-06-09 12:07:33.068427',24,1),(8,'2024-06-09 12:39:00.317986',4,2),(9,'2024-06-09 12:39:01.910225',6,2),(10,'2024-06-09 12:39:03.591348',10,2),(11,'2024-06-09 12:39:04.891378',8,2),(12,'2024-06-09 13:13:51.507452',3,2);
/*!40000 ALTER TABLE `userapp_userfootprint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userapp_userinfo`
--

DROP TABLE IF EXISTS `userapp_userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userapp_userinfo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uname` varchar(254) NOT NULL,
  `pwd` varchar(1000) NOT NULL,
  `uidentity` varchar(50) NOT NULL,
  `balance` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userapp_userinfo`
--

LOCK TABLES `userapp_userinfo` WRITE;
/*!40000 ALTER TABLE `userapp_userinfo` DISABLE KEYS */;
INSERT INTO `userapp_userinfo` VALUES (1,'taoduoduo_official','e10adc3949ba59abbe56e057f20f883e','campus-merchant',800572.00),(2,'a123456','e10adc3949ba59abbe56e057f20f883e','student',95.00),(3,'a12345','e10adc3949ba59abbe56e057f20f883e','student',0.00);
/*!40000 ALTER TABLE `userapp_userinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'netshop'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-23 11:18:45
