-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: venta_carros
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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
-- Current Database: `venta_carros`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `venta_carros` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `venta_carros`;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciudades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ciudades_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciudades`
--

LOCK TABLES `ciudades` WRITE;
/*!40000 ALTER TABLE `ciudades` DISABLE KEYS */;
INSERT INTO `ciudades` VALUES (4,'Barranquilla'),(1,'Bogotá'),(6,'Bucaramanga'),(3,'Cali'),(7,'Cartagena'),(2,'Medellín'),(5,'Villavicencio');
/*!40000 ALTER TABLE `ciudades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combustibles`
--

DROP TABLE IF EXISTS `combustibles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combustibles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_combustibles_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combustibles`
--

LOCK TABLES `combustibles` WRITE;
/*!40000 ALTER TABLE `combustibles` DISABLE KEYS */;
INSERT INTO `combustibles` VALUES (2,'Diésel'),(4,'Eléctrico'),(5,'Gas / Gasolina'),(1,'Gasolina'),(3,'Híbrido');
/*!40000 ALTER TABLE `combustibles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipamientos`
--

DROP TABLE IF EXISTS `equipamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `equipamientos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipamientos_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipamientos`
--

LOCK TABLES `equipamientos` WRITE;
/*!40000 ALTER TABLE `equipamientos` DISABLE KEYS */;
INSERT INTO `equipamientos` VALUES (3,'Airbags'),(1,'Aire Acondicionado'),(5,'Cámara de Reversa'),(2,'Frenos ABS'),(4,'Techo Panorámico / Sunroof');
/*!40000 ALTER TABLE `equipamientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos`
--

DROP TABLE IF EXISTS `favoritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favoritos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `publicacion_id` int(11) NOT NULL,
  `fecha_agregado` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_favorito` (`usuario_id`,`publicacion_id`),
  KEY `idx_fav_publicacion` (`publicacion_id`),
  CONSTRAINT `fk_fav_publicacion` FOREIGN KEY (`publicacion_id`) REFERENCES `publicaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fav_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos`
--

LOCK TABLES `favoritos` WRITE;
/*!40000 ALTER TABLE `favoritos` DISABLE KEYS */;
INSERT INTO `favoritos` VALUES (1,3,2,'2026-11-17 17:09:28'),(2,3,1,'2026-11-17 17:44:53'),(4,3,3,'2026-11-17 17:57:28');
/*!40000 ALTER TABLE `favoritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_precios`
--

DROP TABLE IF EXISTS `historial_precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historial_precios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publicacion_id` int(11) NOT NULL,
  `precio_anterior` decimal(14,2) NOT NULL,
  `precio_nuevo` decimal(14,2) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_hp_publicacion` (`publicacion_id`,`fecha`),
  CONSTRAINT `fk_hp_publicacion` FOREIGN KEY (`publicacion_id`) REFERENCES `publicaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_precios`
--

LOCK TABLES `historial_precios` WRITE;
/*!40000 ALTER TABLE `historial_precios` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_precios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_auditoria`
--

DROP TABLE IF EXISTS `log_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_auditoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tabla` varchar(50) NOT NULL,
  `accion` varchar(10) NOT NULL,
  `registro_id` int(11) DEFAULT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `usuario_bd` varchar(100) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_log_tabla_fecha` (`tabla`,`fecha`),
  CONSTRAINT `ck_log_accion` CHECK (`accion` in ('INSERT','UPDATE','DELETE'))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_auditoria`
--

LOCK TABLES `log_auditoria` WRITE;
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
INSERT INTO `log_auditoria` VALUES (1,'publicaciones','INSERT',1,'Publicación creada. Usuario 2, precio 2300000.00','root@localhost','2026-11-17 16:36:42'),(2,'publicaciones','INSERT',2,'Publicación creada. Usuario 3, precio 3200000.00','root@localhost','2026-11-17 16:37:30'),(3,'usuarios','UPDATE',3,'Cambió la contraseña','root@localhost','2026-11-17 16:45:07'),(4,'usuarios','UPDATE',3,'Cambió la contraseña','root@localhost','2026-11-17 16:46:15'),(5,'publicaciones','INSERT',3,'Publicación creada. Usuario 3, precio 24000000.00','root@localhost','2026-11-17 17:09:21'),(6,'usuarios','UPDATE',3,'Actualización de datos','root@localhost','2026-11-17 17:37:29'),(7,'usuarios','UPDATE',3,'Actualización de datos','root@localhost','2026-11-17 17:51:12'),(8,'usuarios','UPDATE',3,'Actualización de datos','root@localhost','2026-11-17 17:53:04'),(9,'publicaciones','INSERT',4,'Publicación creada. Usuario 4, precio 48990000.00','root@localhost','2026-11-18 15:01:01'),(10,'publicaciones','INSERT',5,'Publicación creada. Usuario 4, precio 30000000.00','root@localhost','2026-11-18 15:04:51'),(11,'publicaciones','INSERT',6,'Publicación creada. Usuario 4, precio 75000000.00','root@localhost','2026-11-18 15:07:06');
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marcas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_marcas_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
INSERT INTO `marcas` VALUES (2,'Chevrolet'),(5,'Mazda'),(4,'Nissan'),(1,'Renault'),(3,'Toyota');
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modelos`
--

DROP TABLE IF EXISTS `modelos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modelos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marca_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_modelos_marca_nombre` (`marca_id`,`nombre`),
  CONSTRAINT `fk_modelos_marca` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modelos`
--

LOCK TABLES `modelos` WRITE;
/*!40000 ALTER TABLE `modelos` DISABLE KEYS */;
INSERT INTO `modelos` VALUES (3,1,'Duster'),(4,1,'Kwid'),(1,1,'Logan'),(2,1,'Sandero'),(5,1,'Stepway'),(9,2,'Captiva'),(6,2,'Onix'),(10,2,'Sail'),(8,2,'Spark'),(7,2,'Tracker'),(11,3,'Corolla'),(13,3,'Fortuner'),(12,3,'Hilux'),(15,3,'Prado'),(14,3,'Yaris'),(19,4,'Frontier'),(18,4,'Kicks'),(17,4,'March'),(20,4,'Sentra'),(16,4,'Versa'),(23,5,'CX-30'),(24,5,'CX-5'),(25,5,'CX-50'),(21,5,'Mazda 2'),(22,5,'Mazda 3');
/*!40000 ALTER TABLE `modelos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicacion_equipamiento`
--

DROP TABLE IF EXISTS `publicacion_equipamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publicacion_equipamiento` (
  `publicacion_id` int(11) NOT NULL,
  `equipamiento_id` int(11) NOT NULL,
  PRIMARY KEY (`publicacion_id`,`equipamiento_id`),
  KEY `idx_pe_equipamiento` (`equipamiento_id`),
  CONSTRAINT `fk_pe_equipamiento` FOREIGN KEY (`equipamiento_id`) REFERENCES `equipamientos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pe_publicacion` FOREIGN KEY (`publicacion_id`) REFERENCES `publicaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicacion_equipamiento`
--

LOCK TABLES `publicacion_equipamiento` WRITE;
/*!40000 ALTER TABLE `publicacion_equipamiento` DISABLE KEYS */;
INSERT INTO `publicacion_equipamiento` VALUES (1,3),(1,4),(2,1),(2,5),(3,4),(4,1),(4,2),(4,3),(4,5),(5,2),(5,3),(6,5);
/*!40000 ALTER TABLE `publicacion_equipamiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicaciones`
--

DROP TABLE IF EXISTS `publicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publicaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `modelo_id` int(11) NOT NULL,
  `ciudad_id` int(11) NOT NULL,
  `transmision_id` int(11) NOT NULL,
  `combustible_id` int(11) NOT NULL,
  `anio` smallint(6) NOT NULL,
  `precio` decimal(14,2) NOT NULL,
  `kilometraje` int(11) NOT NULL DEFAULT 0,
  `descripcion` text DEFAULT NULL,
  `imagen_url` varchar(255) NOT NULL DEFAULT 'img/carro.png',
  `estado` varchar(10) NOT NULL DEFAULT 'activa',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pub_busqueda` (`modelo_id`,`anio`,`precio`),
  KEY `idx_pub_fecha` (`fecha_creacion`),
  KEY `idx_pub_usuario_fecha` (`usuario_id`,`fecha_creacion`),
  KEY `fk_pub_ciudad` (`ciudad_id`),
  KEY `fk_pub_transmision` (`transmision_id`),
  KEY `fk_pub_combustible` (`combustible_id`),
  CONSTRAINT `fk_pub_ciudad` FOREIGN KEY (`ciudad_id`) REFERENCES `ciudades` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pub_combustible` FOREIGN KEY (`combustible_id`) REFERENCES `combustibles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pub_modelo` FOREIGN KEY (`modelo_id`) REFERENCES `modelos` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pub_transmision` FOREIGN KEY (`transmision_id`) REFERENCES `transmisiones` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pub_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_pub_anio` CHECK (`anio` between 1950 and 2100),
  CONSTRAINT `ck_pub_precio` CHECK (`precio` > 0),
  CONSTRAINT `ck_pub_km` CHECK (`kilometraje` >= 0),
  CONSTRAINT `ck_pub_estado` CHECK (`estado` in ('activa','vendida','inactiva'))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicaciones`
--

LOCK TABLES `publicaciones` WRITE;
/*!40000 ALTER TABLE `publicaciones` DISABLE KEYS */;
INSERT INTO `publicaciones` VALUES (1,2,8,5,1,2,2022,2300000.00,334200,'En perfecto estado','img/10761e9265980962ede454adf37dfd1f.png','activa','2026-11-17 16:36:42'),(2,3,12,3,2,2,2021,3200000.00,330000,'No cuenta con papeles al día','img/7c3d3d161629cc239bcc431db9d1ed06.png','activa','2026-11-17 16:37:30'),(3,3,16,1,1,3,2026,24000000.00,0,'Nuevo','img/1c8bc25debdc0d451ebd0d2c3c2777e3.png','activa','2026-11-17 17:09:21'),(4,4,6,1,1,1,2021,48990000.00,35000,'Luego de convertirse en el auto más vendido de la región, llega la nueva generación de este modelo, en su versión sedán, totalmente renovado en su estética y parte mecánica, innovando con la inclusión de un motor de tres cilindros turbo de un litro.','img/c786dd602ec011713481d5adb8b3261e.png','activa','2026-11-18 15:01:01'),(5,4,18,3,1,1,2019,30000000.00,20000,'Esta nueva generación ofrece como argumentos: seguridad, espacio interior, una buena relación valor/precio y está lleno de tecnologías orientadas a favorecer la seguridad de los pasajeros.','img/4239c4f4e263e65bdd00b7bf97466c97.png','activa','2026-11-18 15:04:51'),(6,4,12,5,1,1,2021,75000000.00,223120,'Vehículo en excelente estado de conservación, con pintura original y bien cuidada.','img/3066979fe536c172d65077cb4e742f0b.png','activa','2026-11-18 15:07:06');
/*!40000 ALTER TABLE `publicaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_publicaciones_bi BEFORE INSERT ON publicaciones
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año siguiente.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_publicaciones_ai AFTER INSERT ON publicaciones
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('publicaciones', 'INSERT', NEW.id,
            CONCAT('Publicación creada. Usuario ', NEW.usuario_id, ', precio ', NEW.precio),
            CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_publicaciones_bu BEFORE UPDATE ON publicaciones
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año siguiente.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_publicaciones_au AFTER UPDATE ON publicaciones
FOR EACH ROW
BEGIN
    IF NEW.precio <> OLD.precio THEN
        INSERT INTO historial_precios (publicacion_id, precio_anterior, precio_nuevo)
        VALUES (NEW.id, OLD.precio, NEW.precio);
    END IF;

    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('publicaciones', 'UPDATE', NEW.id,
            CONCAT('Precio: ', OLD.precio, ' -> ', NEW.precio, ' | Estado: ', OLD.estado, ' -> ', NEW.estado),
            CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_publicaciones_ad AFTER DELETE ON publicaciones
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('publicaciones', 'DELETE', OLD.id,
            CONCAT('Publicación eliminada. Precio ', OLD.precio),
            CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_roles_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'administrador','Gestiona usuarios, publicaciones, reportes y auditoría'),(2,'usuario','Publica vehículos, guarda favoritos y edita su cuenta');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transmisiones`
--

DROP TABLE IF EXISTS `transmisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transmisiones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_transmisiones_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transmisiones`
--

LOCK TABLES `transmisiones` WRITE;
/*!40000 ALTER TABLE `transmisiones` DISABLE KEYS */;
INSERT INTO `transmisiones` VALUES (2,'Automática'),(1,'Mecánica');
/*!40000 ALTER TABLE `transmisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol_id` int(11) NOT NULL DEFAULT 2,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_usuarios_correo` (`correo`),
  KEY `fk_usuarios_rol` (`rol_id`),
  CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `ck_usuarios_telefono` CHECK (char_length(`telefono`) between 7 and 20),
  CONSTRAINT `ck_usuarios_activo` CHECK (`activo` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Administrador','3000000001','admin@ventacarros.com','$2y$12$Kk64dA6xs285nbMRE/13SONuHlQf0tHlZxJq/Y3304ujZFwenjCMe',1,1,'2026-11-17 16:34:34'),(2,'Usuario de Prueba','3000000002','usuario@ventacarros.com','$2y$12$72MJ7pblRyfWMcx.hBh.4.RTa6dImQJmoW7n90fpgHD8khBJhkhZ.',2,1,'2026-11-17 16:34:34'),(3,'Laura','3106783181','trabajosu022024@gmail.com','$2y$10$2IZUPHi8jKrNWMbpM1yvqedre4pF2asENRdfN9neAnIRpk22.WpsC',2,1,'2026-11-17 16:36:52'),(4,'Karola','3006783342','karola123@gmail.com','$2y$10$dLZFHJGYB3OJIg.C4fZUj.vtcgiFIHwDZ8eKSNhf29Y2dux.lYyC6',2,1,'2026-11-18 14:52:33');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_usuarios_bi BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre   = TRIM(NEW.nombre);
    SET NEW.telefono = TRIM(NEW.telefono);
    SET NEW.correo   = LOWER(TRIM(NEW.correo));

    IF NEW.correo NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo electrónico no es válido.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_usuarios_bu BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre   = TRIM(NEW.nombre);
    SET NEW.telefono = TRIM(NEW.telefono);
    SET NEW.correo   = LOWER(TRIM(NEW.correo));

    IF NEW.correo NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo electrónico no es válido.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_usuarios_au AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    DECLARE v_detalle VARCHAR(255);

    SET v_detalle = CASE
        WHEN OLD.correo <> NEW.correo AND OLD.telefono <> NEW.telefono THEN 'Cambió el correo y el teléfono'
        WHEN OLD.correo <> NEW.correo     THEN 'Cambió el correo'
        WHEN OLD.telefono <> NEW.telefono THEN 'Cambió el teléfono'
        WHEN OLD.rol_id <> NEW.rol_id     THEN 'Cambió el rol'
        WHEN OLD.activo <> NEW.activo     THEN 'Cambió el estado activo/inactivo'
        WHEN OLD.password <> NEW.password THEN 'Cambió la contraseña'
        ELSE 'Actualización de datos'
    END;

    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('usuarios', 'UPDATE', NEW.id, v_detalle, CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_usuarios_ad AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('usuarios', 'DELETE', OLD.id, CONCAT('Usuario eliminado: ', OLD.correo), CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `v_auditoria_reciente`
--

DROP TABLE IF EXISTS `v_auditoria_reciente`;
/*!50001 DROP VIEW IF EXISTS `v_auditoria_reciente`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_auditoria_reciente` AS SELECT
 1 AS `id`,
  1 AS `tabla`,
  1 AS `accion`,
  1 AS `registro_id`,
  1 AS `detalle`,
  1 AS `usuario_bd`,
  1 AS `fecha` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_favoritos_usuario`
--

DROP TABLE IF EXISTS `v_favoritos_usuario`;
/*!50001 DROP VIEW IF EXISTS `v_favoritos_usuario`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_favoritos_usuario` AS SELECT
 1 AS `usuario_id`,
  1 AS `id`,
  1 AS `vendedor_id`,
  1 AS `marca`,
  1 AS `modelo`,
  1 AS `anio`,
  1 AS `precio`,
  1 AS `precio_formateado`,
  1 AS `categoria_precio`,
  1 AS `kilometraje`,
  1 AS `transmision`,
  1 AS `combustible`,
  1 AS `ciudad`,
  1 AS `descripcion`,
  1 AS `imagen_url`,
  1 AS `estado`,
  1 AS `fecha_creacion`,
  1 AS `antiguedad`,
  1 AS `total_favoritos`,
  1 AS `vendedor_nombre`,
  1 AS `vendedor_telefono`,
  1 AS `equipamiento` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_publicaciones_detalle`
--

DROP TABLE IF EXISTS `v_publicaciones_detalle`;
/*!50001 DROP VIEW IF EXISTS `v_publicaciones_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_publicaciones_detalle` AS SELECT
 1 AS `id`,
  1 AS `vendedor_id`,
  1 AS `marca`,
  1 AS `modelo`,
  1 AS `anio`,
  1 AS `precio`,
  1 AS `precio_formateado`,
  1 AS `categoria_precio`,
  1 AS `kilometraje`,
  1 AS `transmision`,
  1 AS `combustible`,
  1 AS `ciudad`,
  1 AS `descripcion`,
  1 AS `imagen_url`,
  1 AS `estado`,
  1 AS `fecha_creacion`,
  1 AS `antiguedad`,
  1 AS `total_favoritos`,
  1 AS `vendedor_nombre`,
  1 AS `vendedor_telefono`,
  1 AS `equipamiento` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_publicaciones_populares`
--

DROP TABLE IF EXISTS `v_publicaciones_populares`;
/*!50001 DROP VIEW IF EXISTS `v_publicaciones_populares`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_publicaciones_populares` AS SELECT
 1 AS `id`,
  1 AS `marca`,
  1 AS `modelo`,
  1 AS `anio`,
  1 AS `precio_formateado`,
  1 AS `ciudad`,
  1 AS `total_favoritos` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ranking_marcas`
--

DROP TABLE IF EXISTS `v_ranking_marcas`;
/*!50001 DROP VIEW IF EXISTS `v_ranking_marcas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ranking_marcas` AS SELECT
 1 AS `marca_id`,
  1 AS `marca`,
  1 AS `total_publicaciones`,
  1 AS `precio_promedio`,
  1 AS `precio_minimo`,
  1 AS `precio_maximo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_top_vendedores`
--

DROP TABLE IF EXISTS `v_top_vendedores`;
/*!50001 DROP VIEW IF EXISTS `v_top_vendedores`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_top_vendedores` AS SELECT
 1 AS `usuario_id`,
  1 AS `nombre`,
  1 AS `total_publicaciones`,
  1 AS `favoritos_recibidos` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_usuarios_admin`
--

DROP TABLE IF EXISTS `v_usuarios_admin`;
/*!50001 DROP VIEW IF EXISTS `v_usuarios_admin`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_usuarios_admin` AS SELECT
 1 AS `id`,
  1 AS `nombre`,
  1 AS `telefono`,
  1 AS `correo`,
  1 AS `rol_id`,
  1 AS `rol`,
  1 AS `activo`,
  1 AS `fecha_registro`,
  1 AS `total_publicaciones`,
  1 AS `total_favoritos` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'venta_carros'
--

--
-- Dumping routines for database 'venta_carros'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_antiguedad_vehiculo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_antiguedad_vehiculo`(p_anio INT) RETURNS int(11)
    NO SQL
BEGIN
    RETURN GREATEST(YEAR(CURDATE()) - p_anio, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_categoria_precio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_categoria_precio`(p_precio DECIMAL(14,2)) RETURNS varchar(15) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
    IF p_precio < 30000000 THEN
        RETURN 'Económico';
    ELSEIF p_precio < 80000000 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Alto';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_comision_venta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_comision_venta`(p_precio DECIMAL(14,2)) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN
    DECLARE v_tasa DECIMAL(5,4);
    CASE
        WHEN p_precio < 30000000 THEN SET v_tasa = 0.0200;
        WHEN p_precio < 80000000 THEN SET v_tasa = 0.0150;
        ELSE SET v_tasa = 0.0100;
    END CASE;
    RETURN ROUND(p_precio * v_tasa, 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_es_admin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_es_admin`(p_usuario_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    RETURN (SELECT COUNT(*) > 0
              FROM usuarios u
             INNER JOIN roles r ON r.id = u.rol_id
             WHERE u.id = p_usuario_id AND u.activo = 1 AND r.nombre = 'administrador');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_formatear_precio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_formatear_precio`(p_precio DECIMAL(14,2)) RETURNS varchar(30) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
    RETURN CONCAT('$ ', FORMAT(p_precio, 0));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_precio_promedio_marca` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_precio_promedio_marca`(p_marca_id INT) RETURNS decimal(14,2)
    READS SQL DATA
BEGIN
    DECLARE v_prom DECIMAL(14,2);
    SELECT AVG(p.precio) INTO v_prom
    FROM publicaciones p
    INNER JOIN modelos mo ON mo.id = p.modelo_id
    WHERE mo.marca_id = p_marca_id;
    RETURN COALESCE(v_prom, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_total_favoritos_publicacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_total_favoritos_publicacion`(p_publicacion_id INT) RETURNS int(11)
    READS SQL DATA
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM favoritos WHERE publicacion_id = p_publicacion_id;
    RETURN v_total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_total_publicaciones_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_total_publicaciones_usuario`(p_usuario_id INT) RETURNS int(11)
    READS SQL DATA
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM publicaciones WHERE usuario_id = p_usuario_id;
    RETURN v_total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_publicacion_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_publicacion_estado`(
    IN p_admin_id INT,
    IN p_id       INT,
    IN p_estado   VARCHAR(10))
BEGIN
    IF fn_es_admin(p_admin_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acceso denegado: se requiere el rol administrador.';
    ELSEIF NOT EXISTS (SELECT 1 FROM publicaciones WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicación no existe.';
    ELSEIF p_estado NOT IN ('activa', 'vendida', 'inactiva') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido (activa, vendida o inactiva).';
    END IF;

    UPDATE publicaciones SET estado = p_estado WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_usuario_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_usuario_actualizar`(
    IN p_admin_id INT,
    IN p_id       INT,
    IN p_nombre   VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_correo   VARCHAR(150),
    IN p_rol_id   INT,
    IN p_activo   TINYINT)
BEGIN
    DECLARE v_rol_actual INT;

    SET v_rol_actual = (SELECT rol_id FROM usuarios WHERE id = p_id);

    IF fn_es_admin(p_admin_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acceso denegado: se requiere el rol administrador.';
    ELSEIF v_rol_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM roles WHERE id = p_rol_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol indicado no existe.';
    ELSEIF p_activo NOT IN (0, 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado debe ser 0 (inactivo) o 1 (activo).';
    ELSEIF p_id = p_admin_id AND (p_rol_id <> v_rol_actual OR p_activo = 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes quitarte el rol de administrador ni desactivar tu propia cuenta.';
    ELSEIF TRIM(COALESCE(p_nombre, '')) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre no puede estar vacío.';
    ELSEIF CHAR_LENGTH(TRIM(COALESCE(p_telefono, ''))) NOT BETWEEN 7 AND 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El teléfono debe tener entre 7 y 20 caracteres.';
    ELSEIF EXISTS (SELECT 1 FROM usuarios WHERE correo = LOWER(TRIM(p_correo)) AND id <> p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ese correo ya está en uso por otra cuenta.';
    END IF;

    UPDATE usuarios
    SET nombre = p_nombre, telefono = p_telefono, correo = p_correo,
        rol_id = p_rol_id, activo = p_activo
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_usuario_crear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_usuario_crear`(
    IN  p_admin_id INT,
    IN  p_nombre   VARCHAR(100),
    IN  p_telefono VARCHAR(20),
    IN  p_correo   VARCHAR(150),
    IN  p_password VARCHAR(255),
    IN  p_rol_id   INT,
    OUT p_id       INT)
BEGIN
    IF fn_es_admin(p_admin_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acceso denegado: se requiere el rol administrador.';
    ELSEIF NOT EXISTS (SELECT 1 FROM roles WHERE id = p_rol_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El rol indicado no existe.';
    ELSEIF TRIM(COALESCE(p_nombre, '')) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre es obligatorio.';
    ELSEIF CHAR_LENGTH(TRIM(COALESCE(p_telefono, ''))) NOT BETWEEN 7 AND 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El teléfono debe tener entre 7 y 20 caracteres.';
    ELSEIF EXISTS (SELECT 1 FROM usuarios WHERE correo = LOWER(TRIM(p_correo))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo ya se encuentra registrado.';
    END IF;

    INSERT INTO usuarios (nombre, telefono, correo, password, rol_id)
    VALUES (p_nombre, p_telefono, p_correo, p_password, p_rol_id);

    SET p_id = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_admin_usuario_eliminar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_admin_usuario_eliminar`(
    IN p_admin_id INT,
    IN p_id       INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF fn_es_admin(p_admin_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acceso denegado: se requiere el rol administrador.';
    ELSEIF p_id = p_admin_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes eliminar tu propia cuenta de administrador.';
    ELSEIF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe.';
    END IF;

    START TRANSACTION;
        DELETE FROM usuarios WHERE id = p_id;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_favorito_agregar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_favorito_agregar`(
    IN p_usuario_id     INT,
    IN p_publicacion_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = p_usuario_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM publicaciones WHERE id = p_publicacion_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicación no existe.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM favoritos
                    WHERE usuario_id = p_usuario_id AND publicacion_id = p_publicacion_id) THEN
        INSERT INTO favoritos (usuario_id, publicacion_id) VALUES (p_usuario_id, p_publicacion_id);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_favorito_quitar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_favorito_quitar`(
    IN p_usuario_id     INT,
    IN p_publicacion_id INT)
BEGIN
    DELETE FROM favoritos
    WHERE usuario_id = p_usuario_id AND publicacion_id = p_publicacion_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_publicacion_asignar_equipamiento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_publicacion_asignar_equipamiento`(
    IN p_publicacion_id INT,
    IN p_lista          VARCHAR(500))
BEGIN
    DECLARE v_resto  VARCHAR(600);
    DECLARE v_item   VARCHAR(100);
    DECLARE v_pos    INT;
    DECLARE v_eq_id  INT;

    SET v_resto = CONCAT(TRIM(COALESCE(p_lista, '')), ',');

    WHILE CHAR_LENGTH(v_resto) > 0 DO
        SET v_pos   = LOCATE(',', v_resto);
        SET v_item  = TRIM(SUBSTRING(v_resto, 1, v_pos - 1));
        SET v_resto = SUBSTRING(v_resto, v_pos + 1);

        IF v_item <> '' THEN
            SET v_eq_id = (SELECT id FROM equipamientos WHERE nombre = v_item LIMIT 1);
            IF v_eq_id IS NULL THEN
                INSERT INTO equipamientos (nombre) VALUES (v_item);
                SET v_eq_id = LAST_INSERT_ID();
            END IF;
            INSERT IGNORE INTO publicacion_equipamiento (publicacion_id, equipamiento_id)
            VALUES (p_publicacion_id, v_eq_id);
        END IF;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_publicacion_crear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_publicacion_crear`(
    IN  p_usuario_id    INT,
    IN  p_marca         VARCHAR(50),
    IN  p_modelo        VARCHAR(50),
    IN  p_anio          INT,
    IN  p_precio        DECIMAL(14,2),
    IN  p_kilometraje   INT,
    IN  p_transmision   VARCHAR(30),
    IN  p_combustible   VARCHAR(30),
    IN  p_ciudad        VARCHAR(100),
    IN  p_descripcion   TEXT,
    IN  p_imagen_url    VARCHAR(255),
    IN  p_equipamiento  VARCHAR(500),
    OUT p_id            INT)
BEGIN
    DECLARE v_marca_id  INT;
    DECLARE v_modelo_id INT;
    DECLARE v_ciudad_id INT;
    DECLARE v_trans_id  INT;
    DECLARE v_comb_id   INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = p_usuario_id AND activo = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe o está inactivo.';
    END IF;

    SET v_trans_id = (SELECT id FROM transmisiones WHERE nombre = TRIM(p_transmision) LIMIT 1);
    IF v_trans_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La transmisión seleccionada no es válida.';
    END IF;

    SET v_comb_id = (SELECT id FROM combustibles WHERE nombre = TRIM(p_combustible) LIMIT 1);
    IF v_comb_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El combustible seleccionado no es válido.';
    END IF;

    START TRANSACTION;

        SET v_marca_id = (SELECT id FROM marcas WHERE nombre = TRIM(p_marca) LIMIT 1);
        IF v_marca_id IS NULL THEN
            INSERT INTO marcas (nombre) VALUES (TRIM(p_marca));
            SET v_marca_id = LAST_INSERT_ID();
        END IF;

        SET v_modelo_id = (SELECT id FROM modelos
                            WHERE marca_id = v_marca_id AND nombre = TRIM(p_modelo) LIMIT 1);
        IF v_modelo_id IS NULL THEN
            INSERT INTO modelos (marca_id, nombre) VALUES (v_marca_id, TRIM(p_modelo));
            SET v_modelo_id = LAST_INSERT_ID();
        END IF;

        SET v_ciudad_id = (SELECT id FROM ciudades WHERE nombre = TRIM(p_ciudad) LIMIT 1);
        IF v_ciudad_id IS NULL THEN
            INSERT INTO ciudades (nombre) VALUES (TRIM(p_ciudad));
            SET v_ciudad_id = LAST_INSERT_ID();
        END IF;

        INSERT INTO publicaciones
            (usuario_id, modelo_id, ciudad_id, transmision_id, combustible_id,
             anio, precio, kilometraje, descripcion, imagen_url)
        VALUES
            (p_usuario_id, v_modelo_id, v_ciudad_id, v_trans_id, v_comb_id,
             p_anio, p_precio, p_kilometraje, p_descripcion,
             COALESCE(NULLIF(TRIM(p_imagen_url), ''), 'img/carro.png'));

        SET p_id = LAST_INSERT_ID();

        IF p_equipamiento IS NOT NULL AND TRIM(p_equipamiento) <> '' THEN
            CALL sp_publicacion_asignar_equipamiento(p_id, p_equipamiento);
        END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_publicacion_eliminar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_publicacion_eliminar`(
    IN p_id         INT,
    IN p_usuario_id INT)
BEGIN
    DECLARE v_dueno INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET v_dueno = (SELECT usuario_id FROM publicaciones WHERE id = p_id);

    IF v_dueno IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicación no existe.';
    ELSEIF v_dueno <> p_usuario_id AND fn_es_admin(p_usuario_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes eliminar publicaciones de otro usuario.';
    END IF;

    START TRANSACTION;
        DELETE FROM publicaciones WHERE id = p_id;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_actualizar`(
    IN p_id            INT,
    IN p_nombre        VARCHAR(100),
    IN p_telefono      VARCHAR(20),
    IN p_correo        VARCHAR(150),
    IN p_password_hash VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe.';
    ELSEIF TRIM(COALESCE(p_nombre, '')) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre no puede estar vacío.';
    ELSEIF CHAR_LENGTH(TRIM(COALESCE(p_telefono, ''))) NOT BETWEEN 7 AND 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El teléfono debe tener entre 7 y 20 caracteres.';
    ELSEIF EXISTS (SELECT 1 FROM usuarios WHERE correo = LOWER(TRIM(p_correo)) AND id <> p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ese correo ya está en uso por otra cuenta.';
    END IF;

    UPDATE usuarios
    SET nombre   = p_nombre,
        telefono = p_telefono,
        correo   = p_correo,
        password = COALESCE(NULLIF(p_password_hash, ''), password)
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_registrar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_registrar`(
    IN  p_nombre   VARCHAR(100),
    IN  p_telefono VARCHAR(20),
    IN  p_correo   VARCHAR(150),
    IN  p_password VARCHAR(255),
    OUT p_id       INT)
BEGIN
    IF TRIM(COALESCE(p_nombre, '')) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre es obligatorio.';
    ELSEIF CHAR_LENGTH(TRIM(COALESCE(p_telefono, ''))) NOT BETWEEN 7 AND 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El teléfono es obligatorio (entre 7 y 20 caracteres).';
    ELSEIF EXISTS (SELECT 1 FROM usuarios WHERE correo = LOWER(TRIM(p_correo))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo ya se encuentra registrado.';
    END IF;

    INSERT INTO usuarios (nombre, telefono, correo, password)
    VALUES (p_nombre, p_telefono, p_correo, p_password);

    SET p_id = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `venta_carros`
--

USE `venta_carros`;

--
-- Final view structure for view `v_auditoria_reciente`
--

/*!50001 DROP VIEW IF EXISTS `v_auditoria_reciente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_auditoria_reciente` AS select `log_auditoria`.`id` AS `id`,`log_auditoria`.`tabla` AS `tabla`,`log_auditoria`.`accion` AS `accion`,`log_auditoria`.`registro_id` AS `registro_id`,`log_auditoria`.`detalle` AS `detalle`,`log_auditoria`.`usuario_bd` AS `usuario_bd`,`log_auditoria`.`fecha` AS `fecha` from `log_auditoria` order by `log_auditoria`.`id` desc limit 100 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_favoritos_usuario`
--

/*!50001 DROP VIEW IF EXISTS `v_favoritos_usuario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_favoritos_usuario` AS select `f`.`usuario_id` AS `usuario_id`,`d`.`id` AS `id`,`d`.`vendedor_id` AS `vendedor_id`,`d`.`marca` AS `marca`,`d`.`modelo` AS `modelo`,`d`.`anio` AS `anio`,`d`.`precio` AS `precio`,`d`.`precio_formateado` AS `precio_formateado`,`d`.`categoria_precio` AS `categoria_precio`,`d`.`kilometraje` AS `kilometraje`,`d`.`transmision` AS `transmision`,`d`.`combustible` AS `combustible`,`d`.`ciudad` AS `ciudad`,`d`.`descripcion` AS `descripcion`,`d`.`imagen_url` AS `imagen_url`,`d`.`estado` AS `estado`,`d`.`fecha_creacion` AS `fecha_creacion`,`d`.`antiguedad` AS `antiguedad`,`d`.`total_favoritos` AS `total_favoritos`,`d`.`vendedor_nombre` AS `vendedor_nombre`,`d`.`vendedor_telefono` AS `vendedor_telefono`,`d`.`equipamiento` AS `equipamiento` from (`favoritos` `f` join `v_publicaciones_detalle` `d` on(`d`.`id` = `f`.`publicacion_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_publicaciones_detalle`
--

/*!50001 DROP VIEW IF EXISTS `v_publicaciones_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_publicaciones_detalle` AS select `p`.`id` AS `id`,`p`.`usuario_id` AS `vendedor_id`,`ma`.`nombre` AS `marca`,`mo`.`nombre` AS `modelo`,`p`.`anio` AS `anio`,`p`.`precio` AS `precio`,`fn_formatear_precio`(`p`.`precio`) AS `precio_formateado`,`fn_categoria_precio`(`p`.`precio`) AS `categoria_precio`,`p`.`kilometraje` AS `kilometraje`,`tr`.`nombre` AS `transmision`,`co`.`nombre` AS `combustible`,`ci`.`nombre` AS `ciudad`,`p`.`descripcion` AS `descripcion`,`p`.`imagen_url` AS `imagen_url`,`p`.`estado` AS `estado`,`p`.`fecha_creacion` AS `fecha_creacion`,`fn_antiguedad_vehiculo`(`p`.`anio`) AS `antiguedad`,`fn_total_favoritos_publicacion`(`p`.`id`) AS `total_favoritos`,`u`.`nombre` AS `vendedor_nombre`,`u`.`telefono` AS `vendedor_telefono`,(select group_concat(`e`.`nombre` order by `e`.`nombre` ASC separator ', ') from (`publicacion_equipamiento` `pe` join `equipamientos` `e` on(`e`.`id` = `pe`.`equipamiento_id`)) where `pe`.`publicacion_id` = `p`.`id`) AS `equipamiento` from ((((((`publicaciones` `p` join `modelos` `mo` on(`mo`.`id` = `p`.`modelo_id`)) join `marcas` `ma` on(`ma`.`id` = `mo`.`marca_id`)) join `ciudades` `ci` on(`ci`.`id` = `p`.`ciudad_id`)) join `transmisiones` `tr` on(`tr`.`id` = `p`.`transmision_id`)) join `combustibles` `co` on(`co`.`id` = `p`.`combustible_id`)) join `usuarios` `u` on(`u`.`id` = `p`.`usuario_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_publicaciones_populares`
--

/*!50001 DROP VIEW IF EXISTS `v_publicaciones_populares`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_publicaciones_populares` AS select `d`.`id` AS `id`,`d`.`marca` AS `marca`,`d`.`modelo` AS `modelo`,`d`.`anio` AS `anio`,`d`.`precio_formateado` AS `precio_formateado`,`d`.`ciudad` AS `ciudad`,`d`.`total_favoritos` AS `total_favoritos` from `v_publicaciones_detalle` `d` where `d`.`total_favoritos` > 0 and `d`.`total_favoritos` >= (select avg(`x`.`total_favoritos`) from `v_publicaciones_detalle` `x` where `x`.`total_favoritos` > 0) order by `d`.`total_favoritos` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ranking_marcas`
--

/*!50001 DROP VIEW IF EXISTS `v_ranking_marcas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_ranking_marcas` AS select `ma`.`id` AS `marca_id`,`ma`.`nombre` AS `marca`,count(`p`.`id`) AS `total_publicaciones`,round(avg(`p`.`precio`),2) AS `precio_promedio`,min(`p`.`precio`) AS `precio_minimo`,max(`p`.`precio`) AS `precio_maximo` from ((`marcas` `ma` join `modelos` `mo` on(`mo`.`marca_id` = `ma`.`id`)) join `publicaciones` `p` on(`p`.`modelo_id` = `mo`.`id`)) group by `ma`.`id`,`ma`.`nombre` having count(`p`.`id`) >= 1 order by count(`p`.`id`) desc,`ma`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_top_vendedores`
--

/*!50001 DROP VIEW IF EXISTS `v_top_vendedores`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_vendedores` AS select `u`.`id` AS `usuario_id`,`u`.`nombre` AS `nombre`,count(distinct `p`.`id`) AS `total_publicaciones`,count(`f`.`id`) AS `favoritos_recibidos` from ((`usuarios` `u` join `publicaciones` `p` on(`p`.`usuario_id` = `u`.`id`)) left join `favoritos` `f` on(`f`.`publicacion_id` = `p`.`id`)) group by `u`.`id`,`u`.`nombre` having count(distinct `p`.`id`) >= 1 order by count(distinct `p`.`id`) desc,count(`f`.`id`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_usuarios_admin`
--

/*!50001 DROP VIEW IF EXISTS `v_usuarios_admin`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_usuarios_admin` AS select `u`.`id` AS `id`,`u`.`nombre` AS `nombre`,`u`.`telefono` AS `telefono`,`u`.`correo` AS `correo`,`u`.`rol_id` AS `rol_id`,`r`.`nombre` AS `rol`,`u`.`activo` AS `activo`,`u`.`fecha_registro` AS `fecha_registro`,`fn_total_publicaciones_usuario`(`u`.`id`) AS `total_publicaciones`,(select count(0) from `favoritos` `f` where `f`.`usuario_id` = `u`.`id`) AS `total_favoritos` from (`usuarios` `u` join `roles` `r` on(`r`.`id` = `u`.`rol_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-18 15:35:00
