<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

$marca  = $_GET['marca']  ?? '';
$modelo = $_GET['modelo'] ?? '';
$id     = $_GET['id']     ?? '';

try {
    $sql = "SELECT id, marca, modelo, anio, precio, kilometraje, transmision, combustible,
                   ciudad, imagen_url, descripcion, equipamiento,
                   vendedor_nombre, vendedor_telefono, total_favoritos
            FROM v_publicaciones_detalle
            WHERE estado = 'activa'";
    $params = [];

    if (!empty($id)) {
        $sql .= " AND id = :id";
        $params[':id'] = (int)$id;
    }
    if (!empty($marca)) {
        $sql .= " AND LOWER(marca) = LOWER(:marca)";
        $params[':marca'] = $marca;
    }
    if (!empty($modelo)) {
        $sql .= " AND LOWER(modelo) = LOWER(:modelo)";
        $params[':modelo'] = $modelo;
    }

    $sql .= " ORDER BY fecha_creacion DESC";

    $stmt = $conexion->prepare($sql);
    $stmt->execute($params);

    echo json_encode(['success' => true, 'carros' => $stmt->fetchAll()]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al obtener publicaciones: ' . $e->getMessage(), 'carros' => []]);
}
?>