CREATE DATABASE IF NOT EXISTS venta_carros
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE venta_carros;

DROP VIEW IF EXISTS v_favoritos_usuario;
DROP VIEW IF EXISTS v_publicaciones_populares;
DROP VIEW IF EXISTS v_publicaciones_detalle;
DROP VIEW IF EXISTS v_ranking_marcas;
DROP VIEW IF EXISTS v_top_vendedores;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS log_auditoria;
DROP TABLE IF EXISTS historial_precios;
DROP TABLE IF EXISTS publicacion_equipamiento;
DROP TABLE IF EXISTS equipamientos;
DROP TABLE IF EXISTS favoritos;
DROP TABLE IF EXISTS publicaciones;
DROP TABLE IF EXISTS combustibles;
DROP TABLE IF EXISTS transmisiones;
DROP TABLE IF EXISTS ciudades;
DROP TABLE IF EXISTS modelos;
DROP TABLE IF EXISTS marcas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE roles (
    id          INT          AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(30)  NOT NULL,
    descripcion VARCHAR(150) NULL,
    CONSTRAINT uq_roles_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

INSERT INTO roles (id, nombre, descripcion) VALUES
    (1, 'administrador', 'Gestiona usuarios, publicaciones, reportes y auditoría'),
    (2, 'usuario',       'Publica vehículos, guarda favoritos y edita su cuenta');

CREATE TABLE usuarios (
    id             INT          AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20)  NOT NULL,
    correo         VARCHAR(150) NOT NULL,
    password       VARCHAR(255) NOT NULL,
    rol_id         INT          NOT NULL DEFAULT 2,
    activo         TINYINT(1)   NOT NULL DEFAULT 1,
    fecha_registro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_usuarios_correo   UNIQUE (correo),
    CONSTRAINT ck_usuarios_telefono CHECK (CHAR_LENGTH(telefono) BETWEEN 7 AND 20),
    CONSTRAINT ck_usuarios_activo   CHECK (activo IN (0, 1)),
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES roles (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE marcas (
    id     INT         AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT uq_marcas_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE modelos (
    id       INT         AUTO_INCREMENT PRIMARY KEY,
    marca_id INT         NOT NULL,
    nombre   VARCHAR(50) NOT NULL,
    CONSTRAINT uq_modelos_marca_nombre UNIQUE (marca_id, nombre),
    CONSTRAINT fk_modelos_marca FOREIGN KEY (marca_id) REFERENCES marcas (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ciudades (
    id     INT          AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT uq_ciudades_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE transmisiones (
    id     INT         AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT uq_transmisiones_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE combustibles (
    id     INT         AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT uq_combustibles_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE publicaciones (
    id              INT           AUTO_INCREMENT PRIMARY KEY,
    usuario_id      INT           NOT NULL,
    modelo_id       INT           NOT NULL,
    ciudad_id       INT           NOT NULL,
    transmision_id  INT           NOT NULL,
    combustible_id  INT           NOT NULL,
    anio            SMALLINT      NOT NULL,
    precio          DECIMAL(14,2) NOT NULL,
    kilometraje     INT           NOT NULL DEFAULT 0,
    descripcion     TEXT          NULL,
    imagen_url      VARCHAR(255)  NOT NULL DEFAULT 'img/carro.png',
    estado          VARCHAR(10)   NOT NULL DEFAULT 'activa',
    fecha_creacion  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_pub_anio   CHECK (anio BETWEEN 1950 AND 2100),
    CONSTRAINT ck_pub_precio CHECK (precio > 0),
    CONSTRAINT ck_pub_km     CHECK (kilometraje >= 0),
    CONSTRAINT ck_pub_estado CHECK (estado IN ('activa', 'vendida', 'inactiva')),

    KEY idx_pub_busqueda      (modelo_id, anio, precio),
    KEY idx_pub_fecha         (fecha_creacion),
    KEY idx_pub_usuario_fecha (usuario_id, fecha_creacion),

    CONSTRAINT fk_pub_usuario     FOREIGN KEY (usuario_id)     REFERENCES usuarios (id)      ON DELETE CASCADE  ON UPDATE CASCADE,
    CONSTRAINT fk_pub_modelo      FOREIGN KEY (modelo_id)      REFERENCES modelos (id)       ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pub_ciudad      FOREIGN KEY (ciudad_id)      REFERENCES ciudades (id)      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pub_transmision FOREIGN KEY (transmision_id) REFERENCES transmisiones (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pub_combustible FOREIGN KEY (combustible_id) REFERENCES combustibles (id)  ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE favoritos (
    id             INT      AUTO_INCREMENT PRIMARY KEY,
    usuario_id     INT      NOT NULL,
    publicacion_id INT      NOT NULL,
    fecha_agregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_favorito UNIQUE (usuario_id, publicacion_id),
    KEY idx_fav_publicacion (publicacion_id),
    CONSTRAINT fk_fav_usuario     FOREIGN KEY (usuario_id)     REFERENCES usuarios (id)      ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fav_publicacion FOREIGN KEY (publicacion_id) REFERENCES publicaciones (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE equipamientos (
    id     INT          AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80)  NOT NULL,
    CONSTRAINT uq_equipamientos_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE publicacion_equipamiento (
    publicacion_id  INT NOT NULL,
    equipamiento_id INT NOT NULL,
    PRIMARY KEY (publicacion_id, equipamiento_id),
    KEY idx_pe_equipamiento (equipamiento_id),
    CONSTRAINT fk_pe_publicacion  FOREIGN KEY (publicacion_id)  REFERENCES publicaciones (id)  ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pe_equipamiento FOREIGN KEY (equipamiento_id) REFERENCES equipamientos (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE historial_precios (
    id              INT           AUTO_INCREMENT PRIMARY KEY,
    publicacion_id  INT           NOT NULL,
    precio_anterior DECIMAL(14,2) NOT NULL,
    precio_nuevo    DECIMAL(14,2) NOT NULL,
    fecha           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_hp_publicacion (publicacion_id, fecha),
    CONSTRAINT fk_hp_publicacion FOREIGN KEY (publicacion_id) REFERENCES publicaciones (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE log_auditoria (
    id          INT          AUTO_INCREMENT PRIMARY KEY,
    tabla       VARCHAR(50)  NOT NULL,
    accion      VARCHAR(10)  NOT NULL,
    registro_id INT          NULL,
    detalle     VARCHAR(255) NULL,
    usuario_bd  VARCHAR(100) NULL,
    fecha       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_log_accion CHECK (accion IN ('INSERT', 'UPDATE', 'DELETE')),
    KEY idx_log_tabla_fecha (tabla, fecha)
) ENGINE=InnoDB;

INSERT INTO marcas (nombre) VALUES ('Renault'), ('Chevrolet'), ('Toyota'), ('Nissan'), ('Mazda');

INSERT INTO modelos (marca_id, nombre) VALUES
    ((SELECT id FROM marcas WHERE nombre = 'Renault'),   'Logan'),
    ((SELECT id FROM marcas WHERE nombre = 'Renault'),   'Sandero'),
    ((SELECT id FROM marcas WHERE nombre = 'Renault'),   'Duster'),
    ((SELECT id FROM marcas WHERE nombre = 'Renault'),   'Kwid'),
    ((SELECT id FROM marcas WHERE nombre = 'Renault'),   'Stepway'),
    ((SELECT id FROM marcas WHERE nombre = 'Chevrolet'), 'Onix'),
    ((SELECT id FROM marcas WHERE nombre = 'Chevrolet'), 'Tracker'),
    ((SELECT id FROM marcas WHERE nombre = 'Chevrolet'), 'Spark'),
    ((SELECT id FROM marcas WHERE nombre = 'Chevrolet'), 'Captiva'),
    ((SELECT id FROM marcas WHERE nombre = 'Chevrolet'), 'Sail'),
    ((SELECT id FROM marcas WHERE nombre = 'Toyota'),    'Corolla'),
    ((SELECT id FROM marcas WHERE nombre = 'Toyota'),    'Hilux'),
    ((SELECT id FROM marcas WHERE nombre = 'Toyota'),    'Fortuner'),
    ((SELECT id FROM marcas WHERE nombre = 'Toyota'),    'Yaris'),
    ((SELECT id FROM marcas WHERE nombre = 'Toyota'),    'Prado'),
    ((SELECT id FROM marcas WHERE nombre = 'Nissan'),    'Versa'),
    ((SELECT id FROM marcas WHERE nombre = 'Nissan'),    'March'),
    ((SELECT id FROM marcas WHERE nombre = 'Nissan'),    'Kicks'),
    ((SELECT id FROM marcas WHERE nombre = 'Nissan'),    'Frontier'),
    ((SELECT id FROM marcas WHERE nombre = 'Nissan'),    'Sentra'),
    ((SELECT id FROM marcas WHERE nombre = 'Mazda'),     'Mazda 2'),
    ((SELECT id FROM marcas WHERE nombre = 'Mazda'),     'Mazda 3'),
    ((SELECT id FROM marcas WHERE nombre = 'Mazda'),     'CX-30'),
    ((SELECT id FROM marcas WHERE nombre = 'Mazda'),     'CX-5'),
    ((SELECT id FROM marcas WHERE nombre = 'Mazda'),     'CX-50');

INSERT INTO ciudades (nombre) VALUES
    ('Bogotá'), ('Medellín'), ('Cali'), ('Barranquilla'),
    ('Villavicencio'), ('Bucaramanga'), ('Cartagena');

INSERT INTO transmisiones (nombre) VALUES ('Mecánica'), ('Automática');

INSERT INTO combustibles (nombre) VALUES
    ('Gasolina'), ('Diésel'), ('Híbrido'), ('Eléctrico'), ('Gas / Gasolina');

INSERT INTO equipamientos (nombre) VALUES
    ('Aire Acondicionado'), ('Frenos ABS'), ('Airbags'),
    ('Techo Panorámico / Sunroof'), ('Cámara de Reversa');

INSERT INTO usuarios (nombre, telefono, correo, password, rol_id) VALUES
    ('Administrador',    '3000000001', 'admin@ventacarros.com',   '$2y$12$Kk64dA6xs285nbMRE/13SONuHlQf0tHlZxJq/Y3304ujZFwenjCMe', 1),
    ('Usuario de Prueba','3000000002', 'usuario@ventacarros.com', '$2y$12$72MJ7pblRyfWMcx.hBh.4.RTa6dImQJmoW7n90fpgHD8khBJhkhZ.',  2);

DELIMITER $$

DROP FUNCTION IF EXISTS fn_formatear_precio$$
CREATE FUNCTION fn_formatear_precio(p_precio DECIMAL(14,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    RETURN CONCAT('$ ', FORMAT(p_precio, 0));
END$$

DROP FUNCTION IF EXISTS fn_antiguedad_vehiculo$$
CREATE FUNCTION fn_antiguedad_vehiculo(p_anio INT)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN GREATEST(YEAR(CURDATE()) - p_anio, 0);
END$$

DROP FUNCTION IF EXISTS fn_categoria_precio$$
CREATE FUNCTION fn_categoria_precio(p_precio DECIMAL(14,2))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    IF p_precio < 30000000 THEN
        RETURN 'Económico';
    ELSEIF p_precio < 80000000 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Alto';
    END IF;
END$$

DROP FUNCTION IF EXISTS fn_comision_venta$$
CREATE FUNCTION fn_comision_venta(p_precio DECIMAL(14,2))
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    DECLARE v_tasa DECIMAL(5,4);
    CASE
        WHEN p_precio < 30000000 THEN SET v_tasa = 0.0200;
        WHEN p_precio < 80000000 THEN SET v_tasa = 0.0150;
        ELSE SET v_tasa = 0.0100;
    END CASE;
    RETURN ROUND(p_precio * v_tasa, 2);
END$$

DROP FUNCTION IF EXISTS fn_total_publicaciones_usuario$$
CREATE FUNCTION fn_total_publicaciones_usuario(p_usuario_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM publicaciones WHERE usuario_id = p_usuario_id;
    RETURN v_total;
END$$

DROP FUNCTION IF EXISTS fn_total_favoritos_publicacion$$
CREATE FUNCTION fn_total_favoritos_publicacion(p_publicacion_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM favoritos WHERE publicacion_id = p_publicacion_id;
    RETURN v_total;
END$$

DROP FUNCTION IF EXISTS fn_es_admin$$
CREATE FUNCTION fn_es_admin(p_usuario_id INT)
RETURNS TINYINT(1)
READS SQL DATA
BEGIN
    RETURN (SELECT COUNT(*) > 0
              FROM usuarios u
             INNER JOIN roles r ON r.id = u.rol_id
             WHERE u.id = p_usuario_id AND u.activo = 1 AND r.nombre = 'administrador');
END$$

DROP FUNCTION IF EXISTS fn_precio_promedio_marca$$
CREATE FUNCTION fn_precio_promedio_marca(p_marca_id INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_prom DECIMAL(14,2);
    SELECT AVG(p.precio) INTO v_prom
    FROM publicaciones p
    INNER JOIN modelos mo ON mo.id = p.modelo_id
    WHERE mo.marca_id = p_marca_id;
    RETURN COALESCE(v_prom, 0);
END$$

CREATE VIEW v_publicaciones_detalle AS
SELECT
    p.id,
    p.usuario_id                         AS vendedor_id,
    ma.nombre                            AS marca,
    mo.nombre                            AS modelo,
    p.anio,
    p.precio,
    fn_formatear_precio(p.precio)        AS precio_formateado,
    fn_categoria_precio(p.precio)        AS categoria_precio,
    p.kilometraje,
    tr.nombre                            AS transmision,
    co.nombre                            AS combustible,
    ci.nombre                            AS ciudad,
    p.descripcion,
    p.imagen_url,
    p.estado,
    p.fecha_creacion,
    fn_antiguedad_vehiculo(p.anio)       AS antiguedad,
    fn_total_favoritos_publicacion(p.id) AS total_favoritos,
    u.nombre                             AS vendedor_nombre,
    u.telefono                           AS vendedor_telefono,
    (SELECT GROUP_CONCAT(e.nombre ORDER BY e.nombre SEPARATOR ', ')
       FROM publicacion_equipamiento pe
      INNER JOIN equipamientos e ON e.id = pe.equipamiento_id
      WHERE pe.publicacion_id = p.id)    AS equipamiento
FROM publicaciones p
INNER JOIN modelos        mo ON mo.id = p.modelo_id
INNER JOIN marcas         ma ON ma.id = mo.marca_id
INNER JOIN ciudades       ci ON ci.id = p.ciudad_id
INNER JOIN transmisiones  tr ON tr.id = p.transmision_id
INNER JOIN combustibles   co ON co.id = p.combustible_id
INNER JOIN usuarios       u  ON u.id  = p.usuario_id$$

CREATE VIEW v_favoritos_usuario AS
SELECT f.usuario_id, d.*
FROM favoritos f
INNER JOIN v_publicaciones_detalle d ON d.id = f.publicacion_id$$

CREATE VIEW v_ranking_marcas AS
SELECT
    ma.id                  AS marca_id,
    ma.nombre              AS marca,
    COUNT(p.id)            AS total_publicaciones,
    ROUND(AVG(p.precio),2) AS precio_promedio,
    MIN(p.precio)          AS precio_minimo,
    MAX(p.precio)          AS precio_maximo
FROM marcas ma
INNER JOIN modelos        mo ON mo.marca_id = ma.id
INNER JOIN publicaciones  p  ON p.modelo_id = mo.id
GROUP BY ma.id, ma.nombre
HAVING COUNT(p.id) >= 1
ORDER BY total_publicaciones DESC, ma.nombre$$

CREATE VIEW v_top_vendedores AS
SELECT
    u.id                    AS usuario_id,
    u.nombre,
    COUNT(DISTINCT p.id)    AS total_publicaciones,
    COUNT(f.id)             AS favoritos_recibidos
FROM usuarios u
INNER JOIN publicaciones p ON p.usuario_id = u.id
LEFT  JOIN favoritos     f ON f.publicacion_id = p.id
GROUP BY u.id, u.nombre
HAVING COUNT(DISTINCT p.id) >= 1
ORDER BY total_publicaciones DESC, favoritos_recibidos DESC$$

CREATE VIEW v_publicaciones_populares AS
SELECT d.id, d.marca, d.modelo, d.anio, d.precio_formateado, d.ciudad, d.total_favoritos
FROM v_publicaciones_detalle d
WHERE d.total_favoritos > 0
  AND d.total_favoritos >= (SELECT AVG(x.total_favoritos)
                              FROM v_publicaciones_detalle x
                             WHERE x.total_favoritos > 0)
ORDER BY d.total_favoritos DESC$$

CREATE VIEW v_usuarios_admin AS
SELECT
    u.id, u.nombre, u.telefono, u.correo,
    u.rol_id, r.nombre AS rol, u.activo, u.fecha_registro,
    fn_total_publicaciones_usuario(u.id) AS total_publicaciones,
    (SELECT COUNT(*) FROM favoritos f WHERE f.usuario_id = u.id) AS total_favoritos
FROM usuarios u
INNER JOIN roles r ON r.id = u.rol_id$$

CREATE VIEW v_auditoria_reciente AS
SELECT id, tabla, accion, registro_id, detalle, usuario_bd, fecha
FROM log_auditoria
ORDER BY id DESC
LIMIT 100$$

DROP TRIGGER IF EXISTS trg_usuarios_bi$$
CREATE TRIGGER trg_usuarios_bi BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre   = TRIM(NEW.nombre);
    SET NEW.telefono = TRIM(NEW.telefono);
    SET NEW.correo   = LOWER(TRIM(NEW.correo));

    IF NEW.correo NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo electrónico no es válido.';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_usuarios_bu$$
CREATE TRIGGER trg_usuarios_bu BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre   = TRIM(NEW.nombre);
    SET NEW.telefono = TRIM(NEW.telefono);
    SET NEW.correo   = LOWER(TRIM(NEW.correo));

    IF NEW.correo NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo electrónico no es válido.';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_usuarios_au$$
CREATE TRIGGER trg_usuarios_au AFTER UPDATE ON usuarios
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
END$$

DROP TRIGGER IF EXISTS trg_usuarios_ad$$
CREATE TRIGGER trg_usuarios_ad AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('usuarios', 'DELETE', OLD.id, CONCAT('Usuario eliminado: ', OLD.correo), CURRENT_USER());
END$$

DROP TRIGGER IF EXISTS trg_publicaciones_bi$$
CREATE TRIGGER trg_publicaciones_bi BEFORE INSERT ON publicaciones
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año siguiente.';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_publicaciones_bu$$
CREATE TRIGGER trg_publicaciones_bu BEFORE UPDATE ON publicaciones
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año siguiente.';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_publicaciones_ai$$
CREATE TRIGGER trg_publicaciones_ai AFTER INSERT ON publicaciones
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('publicaciones', 'INSERT', NEW.id,
            CONCAT('Publicación creada. Usuario ', NEW.usuario_id, ', precio ', NEW.precio),
            CURRENT_USER());
END$$

DROP TRIGGER IF EXISTS trg_publicaciones_au$$
CREATE TRIGGER trg_publicaciones_au AFTER UPDATE ON publicaciones
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
END$$

DROP TRIGGER IF EXISTS trg_publicaciones_ad$$
CREATE TRIGGER trg_publicaciones_ad AFTER DELETE ON publicaciones
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabla, accion, registro_id, detalle, usuario_bd)
    VALUES ('publicaciones', 'DELETE', OLD.id,
            CONCAT('Publicación eliminada. Precio ', OLD.precio),
            CURRENT_USER());
END$$

DROP PROCEDURE IF EXISTS sp_usuario_registrar$$
CREATE PROCEDURE sp_usuario_registrar(
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
END$$

DROP PROCEDURE IF EXISTS sp_usuario_actualizar$$
CREATE PROCEDURE sp_usuario_actualizar(
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
END$$

DROP PROCEDURE IF EXISTS sp_publicacion_asignar_equipamiento$$
CREATE PROCEDURE sp_publicacion_asignar_equipamiento(
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
END$$

DROP PROCEDURE IF EXISTS sp_publicacion_crear$$
CREATE PROCEDURE sp_publicacion_crear(
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
END$$

DROP PROCEDURE IF EXISTS sp_publicacion_eliminar$$
CREATE PROCEDURE sp_publicacion_eliminar(
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
END$$

DROP PROCEDURE IF EXISTS sp_favorito_agregar$$
CREATE PROCEDURE sp_favorito_agregar(
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
END$$

DROP PROCEDURE IF EXISTS sp_favorito_quitar$$
CREATE PROCEDURE sp_favorito_quitar(
    IN p_usuario_id     INT,
    IN p_publicacion_id INT)
BEGIN
    DELETE FROM favoritos
    WHERE usuario_id = p_usuario_id AND publicacion_id = p_publicacion_id;
END$$

DROP PROCEDURE IF EXISTS sp_admin_usuario_crear$$
CREATE PROCEDURE sp_admin_usuario_crear(
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
END$$

DROP PROCEDURE IF EXISTS sp_admin_usuario_actualizar$$
CREATE PROCEDURE sp_admin_usuario_actualizar(
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
END$$

DROP PROCEDURE IF EXISTS sp_admin_usuario_eliminar$$
CREATE PROCEDURE sp_admin_usuario_eliminar(
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
END$$

DROP PROCEDURE IF EXISTS sp_admin_publicacion_estado$$
CREATE PROCEDURE sp_admin_publicacion_estado(
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
END$$

DELIMITER ;
