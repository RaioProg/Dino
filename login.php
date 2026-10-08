<?php
session_start();
require 'conexion.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.html');
    exit;
}

$login = trim($_POST['email'] ?? '');
$pass  = $_POST['password'] ?? '';

$stmt = $pdo->prepare('SELECT username, password_hash FROM usuarios WHERE username = ? OR email = ? LIMIT 1');
$stmt->execute([$login, $login]);
$fila = $stmt->fetch();

if ($fila && password_verify($pass, $fila['password_hash'])) {
    session_regenerate_id(true);
    $_SESSION['username'] = $fila['username'];
    header('Location: cartas.html');
} else {
    header('Location: index.html?error=login');
}
exit;