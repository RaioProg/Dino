<?php
header('Content-Type: application/json; charset=utf-8');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

$host = '127.0.0.1';
$port = 3306;
$database = 'dinocards';
$username = 'VictorBD';
$password = 'miguelinnieto23';

$status = '';

try {
    $pdo = new PDO(
        "mysql:host=$host;port=$port;dbname=$database;charset=utf8",
        $username,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );

    $sql = 'SELECT nombre, especie, periodo,
                   imagen_url AS imagenUrl,
                   altura, largo, peso,
                   hp, vigor, ataque, defensa, agilidad
            FROM dinosaurios';

    $dinos = $pdo->query($sql)->fetchAll();
    echo json_encode($dinos, JSON_NUMERIC_CHECK);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'No se pudo cargar el catálogo']);
}
?>