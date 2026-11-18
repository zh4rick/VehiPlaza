CREATE USER IF NOT EXISTS 'venta_app'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER IF NOT EXISTS 'venta_app'@'127.0.0.1' IDENTIFIED BY 'admin123';

GRANT SELECT, EXECUTE ON venta_carros.* TO 'venta_app'@'localhost';
GRANT SELECT, EXECUTE ON venta_carros.* TO 'venta_app'@'127.0.0.1';

FLUSH PRIVILEGES;
