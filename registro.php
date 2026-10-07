
<?php
session_start();
// 1. Forzar la visualización de todos los errores de PHP en pantalla
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$host = '127.0.0.1';
$port = 3306;
$database = 'dinocards';
$username = 'VictorBD';
$password = 'miguelinnieto23';

$error = '';
$status = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $email      = $_POST['email'] ?? '';
    $usuario    = $_POST['username'] ?? '';
    $contrasena = $_POST['password'] ?? '';

    $emailLimpio    = filter_var($email, FILTER_SANITIZE_EMAIL);
    $contrasenaHash = password_hash($contrasena, PASSWORD_DEFAULT);

    try {
        $pdo = new PDO("mysql:host=$host;port=$port;dbname=$database;charset=utf8", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        echo "<p>Conectado a la base de datos...</p>";

        $stmt = $pdo->prepare("CALL Registro2(?, ?, ?, @eror)");
        $stmt->execute([
            $usuario,
            $emailLimpio,
            $contrasenaHash,
   
        ]);
        $stmt->closeCursor(); // Importante para liberar el cursor del procedimiento

        // Obtener el valor de salida de MySQL
        $res = $pdo->query("SELECT @eror AS eror")->fetch(PDO::FETCH_ASSOC);
        
        // Evitamos error de índice no definido si @eror viene nulo
        $codigoError = isset($res['eror']) ? (int)$res['eror'] : -999;

        if ($codigoError === 0) {
    session_regenerate_id(true);
    $_SESSION['username'] = $usuario;
    header('Location: cartas.html');
} else {
    header('Location: index.html?error=registro');
}
exit;

    } catch (PDOException $e) {
        $status = "error";
        echo "<p style='color:red; font-weight:bold;'>Error de MySQL / PDO: " . $e->getMessage() . "</p>";
    }
} else {
    echo "<p>Acceso denegado: Envía el formulario desde la página principal.</p>";
}

?>