<?php
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';


function responder($arr) {
    echo json_encode($arr, JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

$accion = $_GET['accion'] ?? '';

try {
    if ($accion === 'perfil') {
        $id = (int)($_GET['usuario_id'] ?? 0);
        $stmt = $conexion->prepare("SELECT id, nombre, telefono, correo FROM usuarios WHERE id = ?");
        $stmt->execute([$id]);
        $u = $stmt->fetch();
        if (!$u) responder(['success' => false, 'mensaje' => 'Usuario no encontrado.']);
        responder(['success' => true, 'usuario' => $u]);
    }

    if ($accion === 'mis_publicaciones') {
        $id = (int)($_GET['usuario_id'] ?? 0);
        $stmt = $conexion->prepare("
            SELECT id, marca, modelo, anio, precio, kilometraje, transmision, combustible,
                   ciudad, imagen_url, estado, total_favoritos
            FROM v_publicaciones_detalle
            WHERE vendedor_id = ?
            ORDER BY fecha_creacion DESC
        ");
        $stmt->execute([$id]);
        responder(['success' => true, 'publicaciones' => $stmt->fetchAll()]);
    }

    if ($accion === 'actualizar') {
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) responder(['success' => false, 'mensaje' => 'Datos inválidos.']);

        $id             = (int)($data['usuario_id'] ?? 0);
        $nombre         = trim($data['nombre'] ?? '');
        $telefono       = trim($data['telefono'] ?? '');
        $correo         = trim($data['correo'] ?? '');
        $passwordActual = $data['password_actual'] ?? '';
        $passwordNueva  = $data['password_nueva'] ?? '';

        $stmt = $conexion->prepare("SELECT * FROM usuarios WHERE id = ?");
        $stmt->execute([$id]);
        $actual = $stmt->fetch();
        if (!$actual) responder(['success' => false, 'mensaje' => 'Usuario no encontrado.']);

        if (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
            responder(['success' => false, 'mensaje' => 'El correo no es válido.']);
        }

        $cambiaCorreo   = (strtolower($correo) !== strtolower($actual['correo']));
        $cambiaPassword = ($passwordNueva !== '');

        if ($cambiaCorreo || $cambiaPassword) {
            if (!password_verify($passwordActual, $actual['password'])) {
                responder(['success' => false, 'mensaje' => 'La contraseña actual es incorrecta.']);
            }
        }
        if ($cambiaPassword && strlen($passwordNueva) < 6) {
            responder(['success' => false, 'mensaje' => 'La nueva contraseña debe tener al menos 6 caracteres.']);
        }

        $hash = $cambiaPassword ? password_hash($passwordNueva, PASSWORD_DEFAULT) : null;

        $upd = $conexion->prepare("CALL sp_usuario_actualizar(?, ?, ?, ?, ?)");
        $upd->execute([$id, $nombre, $telefono, $correo, $hash]);
        $upd->closeCursor();

        responder([
            'success' => true,
            'mensaje' => 'Datos actualizados correctamente.',
            'usuario' => ['id' => $id, 'nombre' => $nombre, 'telefono' => $telefono, 'correo' => strtolower($correo)]
        ]);
    }

    if ($accion === 'eliminar_publicacion') {
        $data = json_decode(file_get_contents('php://input'), true);
        $usuarioId     = (int)($data['usuario_id'] ?? 0);
        $publicacionId = (int)($data['publicacion_id'] ?? 0);

        $img = $conexion->prepare("SELECT imagen_url FROM publicaciones WHERE id = ? AND usuario_id = ?");
        $img->execute([$publicacionId, $usuarioId]);
        $fila = $img->fetch();

        $del = $conexion->prepare("CALL sp_publicacion_eliminar(?, ?)");
        $del->execute([$publicacionId, $usuarioId]);
        $del->closeCursor();

        if ($fila && !empty($fila['imagen_url']) && $fila['imagen_url'] !== 'img/carro.png') {
            $ruta = '../img/' . basename($fila['imagen_url']);
            if (is_file($ruta)) unlink($ruta);
        }

        responder(['success' => true, 'mensaje' => 'Publicación eliminada.']);
    }

    responder(['success' => false, 'mensaje' => 'Acción no válida.']);

} catch (PDOException $e) {
    responder(['success' => false, 'mensaje' => mensajeError($e)]);
}