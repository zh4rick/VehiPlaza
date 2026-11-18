<?php
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

$usuario_id     = (int)($_POST['usuario_id'] ?? 0);
$marca          = trim($_POST['marca'] ?? '');
$modelo         = trim($_POST['modelo'] ?? '');
$anio           = (int)($_POST['anio'] ?? 0);
$precio         = (float)($_POST['precio'] ?? 0);
$km             = (int)($_POST['km'] ?? 0);
$transmision    = trim($_POST['transmision'] ?? '');
$combustible    = trim($_POST['combustible'] ?? '');
$ciudad         = trim($_POST['ciudad'] ?? '');
$descripcion    = trim($_POST['descripcion'] ?? '');
$equipamiento   = trim($_POST['equipamiento'] ?? '');   // "Airbags,Frenos ABS,..."

if ($usuario_id <= 0 || $marca === '' || $modelo === '' || $ciudad === '') {
    echo json_encode(['success' => false, 'mensaje' => 'Faltan datos obligatorios.']);
    exit;
}

if ($anio < 1950 || $anio > (int)date('Y') + 1) {
    echo json_encode(['success' => false, 'mensaje' => 'El año del vehículo no es válido.']);
    exit;
}
if ($precio <= 0) {
    echo json_encode(['success' => false, 'mensaje' => 'El precio debe ser mayor a cero.']);
    exit;
}
if ($km < 0) {
    echo json_encode(['success' => false, 'mensaje' => 'El kilometraje no puede ser negativo.']);
    exit;
}

$imagen_url    = 'img/carro.png';
$archivoSubido = null;

if (isset($_FILES['imagen']) && $_FILES['imagen']['error'] === UPLOAD_ERR_OK) {
    $fileExtension = strtolower(pathinfo($_FILES['imagen']['name'], PATHINFO_EXTENSION));
    $permitidas    = ['jpg', 'jpeg', 'png', 'webp'];

    if (!in_array($fileExtension, $permitidas)) {
        echo json_encode(['success' => false, 'mensaje' => 'Formato de imagen no permitido (usa JPG, PNG o WEBP).']);
        exit;
    }
    if ($_FILES['imagen']['size'] > 5 * 1024 * 1024) {
        echo json_encode(['success' => false, 'mensaje' => 'La imagen no debe pesar más de 5 MB.']);
        exit;
    }

    $newFileName   = md5(time() . $_FILES['imagen']['name']) . '.' . $fileExtension;
    $uploadFileDir = '../img/';
    if (!is_dir($uploadFileDir)) {
        mkdir($uploadFileDir, 0755, true);
    }

    $dest_path = $uploadFileDir . $newFileName;
    if (move_uploaded_file($_FILES['imagen']['tmp_name'], $dest_path)) {
        $imagen_url    = 'img/' . $newFileName;
        $archivoSubido = $dest_path;
    }
}

try {
    $stmt = $conexion->prepare(
        "CALL sp_publicacion_crear(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, @pub_id)"
    );
    $stmt->execute([
        $usuario_id, $marca, $modelo, $anio, $precio, $km,
        $transmision, $combustible, $ciudad, $descripcion, $imagen_url, $equipamiento
    ]);
    $stmt->closeCursor();

    $carroId = $conexion->query("SELECT @pub_id AS id")->fetch()['id'];

    echo json_encode(['success' => true, 'carro_id' => (int)$carroId, 'mensaje' => 'Vehículo publicado con éxito.']);

} catch (PDOException $e) {
    if ($archivoSubido && file_exists($archivoSubido)) {
        unlink($archivoSubido);
    }
    echo json_encode(['success' => false, 'mensaje' => mensajeError($e)]);
}
?>