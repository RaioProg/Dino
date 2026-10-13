<?php
// Devuelve el catálogo completo de dinosaurios en JSON.
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

// Solo se permite GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

// Reutiliza la conexión (aquí están las credenciales, no se repiten)
require 'conexion.php';

try {
    // Usa el procedimiento almacenado de DinoCards.sql
    $stmt = $pdo->query('CALL ObtenerDinosaurios()');
    $dinos = $stmt->fetchAll();
    $stmt->closeCursor();

    // Filtro opcional por periodo: dinos.php?periodo=jurasico
    if (!empty($_GET['periodo'])) {
        $quitarTildes = fn($s) => strtr(
            mb_strtolower((string)$s, 'UTF-8'),
            ['á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u']
        );
        $periodo = $quitarTildes($_GET['periodo']);
        $dinos = array_values(array_filter(
            $dinos,
            fn($d) => $quitarTildes($d['periodo']) === $periodo
        ));
    }

    echo json_encode($dinos, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'No se pudo cargar el catálogo']);
}