<?php

if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 60 * 60 * 24 * 7,  
        'path'     => '/',
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}

function usuarioSesionId() {
    return isset($_SESSION['usuario_id']) ? (int)$_SESSION['usuario_id'] : 0;
}

function responderSesion($codigo, $mensaje) {
    http_response_code($codigo);
    echo json_encode(['success' => false, 'mensaje' => $mensaje]);
    exit;
}

function requerirSesion() {
    $id = usuarioSesionId();
    if ($id <= 0) responderSesion(401, 'Debes iniciar sesión.');
    return $id;
}

function requerirAdmin(PDO $conexion) {
    $id = requerirSesion();
    $stmt = $conexion->prepare("SELECT fn_es_admin(?)");
    $stmt->execute([$id]);
    if ((int)$stmt->fetchColumn() !== 1) {
        responderSesion(403, 'Acceso restringido a administradores.');
    }
    return $id;
}
