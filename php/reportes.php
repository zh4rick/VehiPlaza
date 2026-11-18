<?php
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

$vistas = [
    'marcas'     => 'v_ranking_marcas',
    'vendedores' => 'v_top_vendedores',
    'populares'  => 'v_publicaciones_populares'
];

$tipo = $_GET['tipo'] ?? '';

if (!isset($vistas[$tipo])) {
    echo json_encode(['success' => false, 'mensaje' => 'Reporte no válido.']);
    exit;
}

try {
    $stmt = $conexion->query("SELECT * FROM " . $vistas[$tipo] . " LIMIT 20");
    echo json_encode(['success' => true, 'datos' => $stmt->fetchAll()], JSON_INVALID_UTF8_SUBSTITUTE);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'mensaje' => 'Error al generar el reporte: ' . $e->getMessage()]);
}
?>