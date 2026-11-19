<?php
$rutaEnv = __DIR__ . '/../.env';

if (!is_file($rutaEnv)) {
    echo json_encode([
        "success" => false,
        "mensaje" => "Falta el archivo .env. Copia .env.example como .env y completa los datos."
    ]);
    exit;
}

$env = parse_ini_file($rutaEnv, false, INI_SCANNER_RAW);

$host       = $env['DB_HOST'] ?? 'localhost';
$port       = $env['DB_PORT'] ?? '3306';
$usuario    = $env['DB_USER'] ?? '';
$password   = $env['DB_PASS'] ?? '';
$base_datos = $env['DB_NAME'] ?? 'venta_carros';

if ($usuario === '' || in_array(strtolower($usuario), ['root', 'admin'], true)) {
    echo json_encode([
        "success" => false,
        "mensaje" => "La aplicación no debe usar el usuario root ni admin. Usa el usuario venta_app (bd/usuario_app.sql)."
    ]);
    exit;
}

try {
    $conexion = new PDO("mysql:host=$host;port=$port;dbname=$base_datos;charset=utf8mb4", $usuario, $password);
    $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conexion->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "mensaje" => "Error de conexión a la base de datos: " . $e->getMessage()
    ]);
    exit;
}

function mensajeError(PDOException $e) {
    if (isset($e->errorInfo[0]) && $e->errorInfo[0] === '45000' && !empty($e->errorInfo[2])) {
        return $e->errorInfo[2];
    }
    return 'Error en la base de datos: ' . $e->getMessage();
}
?>