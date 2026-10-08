<?php
session_start();
require 'conexion.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.html');
    exit;
}

$usuario    = trim($_POST['username'] ?? '');
$email      = filter_var(trim($_POST['email'] ?? ''), FILTER_SANITIZE_EMAIL);
$contrasena = $_POST['password'] ?? '';
$repetida   = $_POST['password_repetida'] ?? '';

if ($contrasena !== $repetida || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    header('Location: index.html?error=registro');
    exit;
}

try {
    $hash = password_hash($contrasena, PASSWORD_DEFAULT);

    $stmt = $pdo->prepare('CALL Registro2(?, ?, ?, @eror)');
    $stmt->execute([$usuario, $email, $hash]);
    $stmt->closeCursor();

    $res = $pdo->query('SELECT @eror AS eror')->fetch();
    $codigo = isset($res['eror']) ? (int)$res['eror'] : -999;

    if ($codigo === 0) {
        session_regenerate_id(true);
        $_SESSION['username'] = $usuario;
        header('Location: cartas.html');
        die('Código: ' . $codigo);
    } else {
        header('Location: index.html?error=registro');
    }
} catch (PDOException $e) {
    // por ejemplo, correo duplicado
    header('Location: index.html?error=registro');
    die('Error: ' . $e->getMessage());
}
exit;