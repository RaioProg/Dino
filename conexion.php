<?php
$pdo = new PDO(
    'mysql:host=127.0.0.1;port=3306;dbname=dinocards;charset=utf8mb4',
    'VictorBD', 'miguelinnieto23',
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
);