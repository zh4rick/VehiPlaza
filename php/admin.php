<?php
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';
require_once 'sesion.php';

$adminId = requerirAdmin($conexion);

function responder($arr) {
    echo json_encode($arr, JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

$accion = $_GET['accion'] ?? '';
$data   = json_decode(file_get_contents('php://input'), true) ?: [];

try {
    if ($accion === 'usuarios') {
        $usuarios = $conexion->query("SELECT * FROM v_usuarios_admin ORDER BY id")->fetchAll();
        $roles    = $conexion->query("SELECT id, nombre FROM roles ORDER BY id")->fetchAll();
        responder(['success' => true, 'usuarios' => $usuarios, 'roles' => $roles, 'yo' => $adminId]);
    }

    if ($accion === 'usuario_crear') {
        $password = trim($data['password'] ?? '');
        if (strlen($password) < 6) {
            responder(['success' => false, 'mensaje' => 'La contraseña debe tener al menos 6 caracteres.']);
        }
        $stmt = $conexion->prepare("CALL sp_admin_usuario_crear(?, ?, ?, ?, ?, ?, @nuevo_id)");
        $stmt->execute([
            $adminId, trim($data['nombre'] ?? ''), trim($data['telefono'] ?? ''),
            trim($data['correo'] ?? ''), password_hash($password, PASSWORD_DEFAULT), (int)($data['rol_id'] ?? 2)
        ]);
        $stmt->closeCursor();
        responder(['success' => true, 'mensaje' => 'Usuario creado correctamente.']);
    }

    if ($accion === 'usuario_actualizar') {
        $stmt = $conexion->prepare("CALL sp_admin_usuario_actualizar(?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([
            $adminId, (int)($data['id'] ?? 0), trim($data['nombre'] ?? ''), trim($data['telefono'] ?? ''),
            trim($data['correo'] ?? ''), (int)($data['rol_id'] ?? 2), (int)($data['activo'] ?? 1)
        ]);
        $stmt->closeCursor();
        responder(['success' => true, 'mensaje' => 'Usuario actualizado correctamente.']);
    }

    if ($accion === 'usuario_eliminar') {
        $stmt = $conexion->prepare("CALL sp_admin_usuario_eliminar(?, ?)");
        $stmt->execute([$adminId, (int)($data['id'] ?? 0)]);
        $stmt->closeCursor();
        responder(['success' => true, 'mensaje' => 'Usuario eliminado.']);
    }

    if ($accion === 'publicaciones') {
        $pub = $conexion->query("
            SELECT id, marca, modelo, anio, precio, ciudad, estado, vendedor_nombre, total_favoritos
            FROM v_publicaciones_detalle
            ORDER BY fecha_creacion DESC
            LIMIT 200
        ")->fetchAll();
        responder(['success' => true, 'publicaciones' => $pub]);
    }

    if ($accion === 'publicacion_estado') {
        $stmt = $conexion->prepare("CALL sp_admin_publicacion_estado(?, ?, ?)");
        $stmt->execute([$adminId, (int)($data['id'] ?? 0), trim($data['estado'] ?? '')]);
        $stmt->closeCursor();
        responder(['success' => true, 'mensaje' => 'Estado actualizado.']);
    }

    if ($accion === 'publicacion_eliminar') {
        $pubId = (int)($data['id'] ?? 0);

        $img = $conexion->prepare("SELECT imagen_url FROM publicaciones WHERE id = ?");
        $img->execute([$pubId]);
        $fila = $img->fetch();

        $stmt = $conexion->prepare("CALL sp_publicacion_eliminar(?, ?)");
        $stmt->execute([$pubId, $adminId]);
        $stmt->closeCursor();

        if ($fila && !empty($fila['imagen_url']) && $fila['imagen_url'] !== 'img/carro.png') {
            $ruta = '../img/' . basename($fila['imagen_url']);
            if (is_file($ruta)) unlink($ruta);
        }
        responder(['success' => true, 'mensaje' => 'Publicación eliminada.']);
    }

    if ($accion === 'auditoria') {
        $log = $conexion->query("SELECT * FROM v_auditoria_reciente")->fetchAll();
        responder(['success' => true, 'auditoria' => $log]);
    }

    responder(['success' => false, 'mensaje' => 'Acción no válida.']);

} catch (PDOException $e) {
    responder(['success' => false, 'mensaje' => mensajeError($e)]);
}
