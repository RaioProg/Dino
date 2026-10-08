<?php
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
session_start();

if (empty($_SESSION['username'])) {
    http_response_code(401);
    echo json_encode(['error' => 'No has iniciado sesión']);
    exit;
}

require 'conexion.php';
$usuario = $_SESSION['username'];

const CARTAS_POR_SOBRE = 5;
const ESPEREA_SEGUNDOS = 30; // 24 h (pon 30 para probar)

function norm($s) {
    return strtr(mb_strtolower((string)$s, 'UTF-8'),
        ['á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u']);
}

function catalogo(PDO $pdo) {
    $stmt = $pdo->query('CALL ObtenerDinosaurios()');
    $filas = $stmt->fetchAll();
    $stmt->closeCursor();
    return $filas;
}

function coleccionDe(PDO $pdo, $usuario) {
    $stmt = $pdo->prepare('CALL ObtenerColeccion(?)');
    $stmt->execute([$usuario]);
    $filas = $stmt->fetchAll();
    $stmt->closeCursor();
    return $filas;
}

const ESPERA_SEGUNDOS = 86400; // 24 h (pon 30 para probar)

function segundosRestantes(PDO $pdo, $usuario) {
    $stmt = $pdo->prepare(
        'SELECT COALESCE(GREATEST(0, ? - TIMESTAMPDIFF(SECOND, ultimo_sobre, NOW())), 0) AS r
         FROM usuarios WHERE username = ?'
    );
    $stmt->execute([ESPERA_SEGUNDOS, $usuario]);
    return (int)$stmt->fetchColumn();
}

try {
    $sacadas = [];

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $periodo = norm($_POST['periodo'] ?? '');
        $restante = segundosRestantes($pdo, $usuario);
    if ($restante > 0) {
        http_response_code(429);
        echo json_encode(['error' => 'Aún no puedes abrir otro sobre', 'restante' => $restante]);
        exit;
    }
        $pool = array_values(array_filter(
            catalogo($pdo),
            fn($d) => norm($d['periodo']) === $periodo
        ));

        if (!$pool) {
            http_response_code(400);
            echo json_encode(['error' => 'Periodo no válido']);
            exit;
        }

        shuffle($pool);
        $sacadas = array_slice($pool, 0, CARTAS_POR_SOBRE);

        $pdo->beginTransaction();
        $ins = $pdo->prepare(
            'INSERT INTO colecciones (usuario_id, dinosaurio_id)
             SELECT u.id, d.id FROM usuarios u, dinosaurios d
             WHERE u.username = ? AND d.nombre = ?'
        );
        foreach ($sacadas as $d) {
            $ins->execute([$usuario, $d['nombre']]);
        }
        $pdo->prepare('UPDATE usuarios SET ultimo_sobre = NOW() WHERE username = ?')->execute([$usuario]);
        $pdo->commit();
    }

    echo json_encode([
        'usuario'   => $usuario,
        'sacadas'   => $sacadas,
        'coleccion' => coleccionDe($pdo, $usuario),
        'restante'  => segundosRestantes($pdo, $usuario),
    ], JSON_NUMERIC_CHECK);

} catch (PDOException $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    http_response_code(500);
    echo json_encode(['error' => 'Error en la base de datos', 'detalle' => $e->getMessage()]);
}