<?php
header('Content-Type: application/json; charset=utf-8');
session_start();

// Solo usuarios con sesión iniciada
if (empty($_SESSION['username'])) {
    http_response_code(401);
    echo json_encode(['error' => 'No has iniciado sesión']);
    exit;
}

require 'conexion.php';
$usuario = $_SESSION['username'];

const CARTAS_POR_SOBRE = 5;

// "Jurásico" -> "jurasico"
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

try {
    $sacadas = [];

    // POST con "periodo": abrir un sobre
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $periodo = norm($_POST['periodo'] ?? '');

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
        $ins = $pdo->prepare('INSERT INTO colecciones (usuario_id, dinosaurio_id) 
        SELECT u.id, d.id FROM usuarios u, dinosaurios d WHERE u.username = ? AND d.nombre = ?'
);
        foreach ($sacadas as $d) {
            $ins->execute([$usuario, $d['nombre']]);
        }
        $pdo->commit();
    }

    // GET (o tras abrir un sobre): devolver la colección actualizada
    echo json_encode([
        'usuario'   => $usuario,
        'sacadas'   => $sacadas,
        'coleccion' => coleccionDe($pdo, $usuario),
    ], JSON_NUMERIC_CHECK);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    http_response_code(500);
    echo json_encode(['error' => 'Error en la base de datos']);
}