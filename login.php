<?php
// 1. Forzar la visualización de todos los errores de PHP en pantalla
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start(); // NUEVO: necesario para recordar al usuario tras el login

$host = '127.0.0.1';
$port = 3306;
$database = 'dinocards';
$username = 'VictorBD';
$password = 'miguelinnieto23';

$status = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // CAMBIO: el formulario envía "email", no "usuario"
    $email      = trim($_POST['email'] ?? '');
    $contrasena = $_POST['password'] ?? ''; // sin trim: se usa tal cual la escribió el usuario

    try {
        $pdo = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        if ($email === '' || $contrasena === '') {
            echo "<p style='color:red;'>Error: El correo y la contraseña no pueden estar vacíos.</p>";
            $status = "error";
        } else {
            // CAMBIO: en vez de CALL LOGIN2, buscamos el hash del usuario
            $stmt = $pdo->prepare("Call LOGIN2(?, @password_hash, @eror)");
            $stmt->execute([$email]);
            $fila = $stmt->fetch(PDO::FETCH_ASSOC);

            // NUEVO: verificación de la contraseña contra el hash guardado
            if ($fila && password_verify($contrasena, $fila['password_hash'])) {
                session_regenerate_id(true); // evita robo de sesión
                $_SESSION['username'] = $fila['username'];

                echo "<p style='color:green; font-weight:bold;'>¡Inicio de sesión exitoso!</p>";
                $status = "success";
                // header("Location: juego.php"); exit; // descomenta para redirigir
            } else {
                // Mismo mensaje si el correo no existe o la contraseña es incorrecta
                echo "<p style='color:red;'>Error: Correo o contraseña incorrectos.</p>";
                $status = "error";
            }
        }
    } catch (PDOException $e) {
        $status = "error";
        echo "<p style='color:red; font-weight:bold;'>Error de MySQL / PDO: " . $e->getMessage() . "</p>";
    }
} else {
    echo "<p>Acceso denegado: Envía el formulario desde la página principal.</p>";
}
header("Location: cartas.html");
exit;
?>