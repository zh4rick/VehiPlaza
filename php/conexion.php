<?php
$host = "localhost";
$port = "3307";
$usuario = "venta_app";
$password = "admin123";
$base_datos = "venta_carros";

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