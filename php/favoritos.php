<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

$data = json_decode(file_get_contents('php://input'), true);

if (!$data || !isset($data['usuario_id']) || !isset($data['publicacion_id'])) {
    echo json_encode(['success' => false, 'mensaje' => 'Datos incompletos.']);
    exit;
}

$usuarioId     = (int)$data['usuario_id'];
$publicacionId = (int)$data['publicacion_id'];
$accion        = $data['accion'] ?? 'agregar';

try {
    if ($accion === 'quitar') {
        $stmt = $conexion->prepare("CALL sp_favorito_quitar(?, ?)");
        $stmt->execute([$usuarioId, $publicacionId]);
        echo json_encode(['success' => true, 'mensaje' => 'Vehículo quitado de tus favoritos.']);
    } else {
        $stmt = $conexion->prepare("CALL sp_favorito_agregar(?, ?)");
        $stmt->execute([$usuarioId, $publicacionId]);
        echo json_encode(['success' => true, 'mensaje' => 'Vehículo agregado a favoritos.']);
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'mensaje' => mensajeError($e)]);
}
?>