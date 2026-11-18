USE venta_carros;

SELECT 'Tablas'         AS objeto, COUNT(*) AS total FROM information_schema.TABLES   WHERE TABLE_SCHEMA = 'venta_carros' AND TABLE_TYPE = 'BASE TABLE'
UNION ALL
SELECT 'Vistas',         COUNT(*) FROM information_schema.VIEWS     WHERE TABLE_SCHEMA = 'venta_carros'
UNION ALL
SELECT 'Procedimientos', COUNT(*) FROM information_schema.ROUTINES  WHERE ROUTINE_SCHEMA = 'venta_carros' AND ROUTINE_TYPE = 'PROCEDURE'
UNION ALL
SELECT 'Funciones',      COUNT(*) FROM information_schema.ROUTINES  WHERE ROUTINE_SCHEMA = 'venta_carros' AND ROUTINE_TYPE = 'FUNCTION'
UNION ALL
SELECT 'Triggers',       COUNT(*) FROM information_schema.TRIGGERS  WHERE TRIGGER_SCHEMA = 'venta_carros';

SELECT 'roles' AS tabla, COUNT(*) AS filas FROM venta_carros.roles
UNION ALL SELECT 'usuarios', COUNT(*) FROM venta_carros.usuarios
UNION ALL SELECT 'marcas', COUNT(*) FROM venta_carros.marcas
UNION ALL SELECT 'modelos', COUNT(*) FROM venta_carros.modelos
UNION ALL SELECT 'ciudades', COUNT(*) FROM venta_carros.ciudades
UNION ALL SELECT 'publicaciones', COUNT(*) FROM venta_carros.publicaciones
UNION ALL SELECT 'favoritos', COUNT(*) FROM venta_carros.favoritos
UNION ALL SELECT 'historial_precios', COUNT(*) FROM venta_carros.historial_precios
UNION ALL SELECT 'log_auditoria', COUNT(*) FROM venta_carros.log_auditoria;

SELECT venta_carros.fn_es_admin(1) AS admin_es_admin, venta_carros.fn_es_admin(2) AS usuario_es_admin;
