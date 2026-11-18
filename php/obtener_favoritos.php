<?php
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

$usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : 0;

if ($usuario_id <= 0) {
    echo json_encode(['success' => false, 'mensaje' => 'Usuario no especificado.']);
    exit;
}

try {
    $stmt = $conexion->prepare("
        SELECT id, marca, modelo, anio, precio, kilometraje, transmision, combustible, ciudad, imagen_url
        FROM v_favoritos_usuario
        WHERE usuario_id = ?
        ORDER BY id DESC
    ");
    $stmt->execute([$usuario_id]);

    echo json_encode(['success' => true, 'favoritos' => $stmt->fetchAll()], JSON_INVALID_UTF8_SUBSTITUTE);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al obtener favoritos: ' . $e->getMessage()]);
}
?>