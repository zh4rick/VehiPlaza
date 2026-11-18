<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';
require_once 'sesion.php';

$accion = $_GET['accion'] ?? '';

function datosUsuario(PDO $conexion, int $id) {
    $stmt = $conexion->prepare(
        "SELECT u.id, u.nombre, u.correo, u.telefono, r.nombre AS rol
         FROM usuarios u JOIN roles r ON r.id = u.rol_id
         WHERE u.id = ? AND u.activo = 1"
    );
    $stmt->execute([$id]);
    return $stmt->fetch();
}

if ($accion === 'sesion') {
    $id = usuarioSesionId();
    $usuario = $id > 0 ? datosUsuario($conexion, $id) : false;
    if ($usuario) {
        echo json_encode(['success' => true, 'usuario' => $usuario]);
    } else {
        echo json_encode(['success' => false, 'sesion' => false, 'mensaje' => 'No hay sesión iniciada.']);
    }
    exit;
}

if ($accion === 'logout') {
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $p = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
    }
    session_destroy();
    echo json_encode(['success' => true]);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!$data) {
    echo json_encode(['success' => false, 'mensaje' => 'Datos inválidos.']);
    exit;
}

if ($accion === 'registro') {
    $nombre   = trim($data['nombre'] ?? '');
    $telefono = trim($data['telefono'] ?? '');
    $correo   = trim($data['correo'] ?? '');
    $password = trim($data['password'] ?? '');

    if ($nombre === '' || $telefono === '' || $correo === '' || $password === '') {
        echo json_encode(['success' => false, 'mensaje' => 'Por favor completa todos los campos.']);
        exit;
    }

    try {
        $passwordHash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $conexion->prepare("CALL sp_usuario_registrar(?, ?, ?, ?, @nuevo_id)");
        $stmt->execute([$nombre, $telefono, $correo, $passwordHash]);
        $stmt->closeCursor();

        $id = $conexion->query("SELECT @nuevo_id AS id")->fetch()['id'];

        echo json_encode(['success' => true, 'mensaje' => 'Usuario registrado exitosamente.', 'id' => (int)$id]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'mensaje' => mensajeError($e)]);
    }
}
else if ($accion === 'login') {
    $correo   = trim($data['correo'] ?? '');
    $password = trim($data['password'] ?? '');

    try {
        $stmt = $conexion->prepare(
            "SELECT u.id, u.nombre, u.correo, u.telefono, u.password, r.nombre AS rol
             FROM usuarios u JOIN roles r ON r.id = u.rol_id
             WHERE u.correo = ? AND u.activo = 1"
        );
        $stmt->execute([$correo]);
        $usuario = $stmt->fetch();

        if ($usuario && password_verify($password, $usuario['password'])) {
            session_regenerate_id(true);
            $_SESSION['usuario_id'] = (int)$usuario['id'];

            echo json_encode([
                'success' => true,
                'usuario' => [
                    'id'       => $usuario['id'],
                    'nombre'   => $usuario['nombre'],
                    'correo'   => $usuario['correo'],
                    'telefono' => $usuario['telefono'],
                    'rol'      => $usuario['rol']
                ]
            ]);
        } else {
            echo json_encode(['success' => false, 'mensaje' => 'Correo o contraseña incorrectos.']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'mensaje' => 'Error al iniciar sesión: ' . $e->getMessage()]);
    }
}
else {
    echo json_encode(['success' => false, 'mensaje' => 'Acción no válida.']);
}
?>