<?php

header('Content-Type: application/json');

// Configuración de la base de datos
$db_host = "localhost";
$db_user = "root";
$db_pass = "1234"; // Contraseña de tu base de datos
$db_name = "control-mindbox"; // Nombre de la base de datos

// Conexión a la base de datos
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

// Verificar conexión
if ($conn->connect_error) {
    die(json_encode(["error" => "Conexión fallida: " . $conn->connect_error]));
}

// Verificar si se recibió el parámetro num
if (!isset($_GET['num']) || empty($_GET['num'])) {
    echo json_encode(["error" => "Falta el parámetro 'num'."]);
    exit;
}

$num = $conn->real_escape_string($_GET['num']); // Sanitizar entrada

// Verificar si el número ya está registrado
$sql_check = "SELECT id FROM estudiantes WHERE numero_control = '$num'";
$result = $conn->query($sql_check);

if ($result->num_rows > 0) {
    // Número ya registrado
    echo json_encode(["success" => false, "message" => "El número ya está registrado."]);
} else {
    // Registrar el nuevo número
    $sql_insert = "INSERT INTO estudiantes (numero_control) VALUES ('$num')";
    if ($conn->query($sql_insert) === TRUE) {
        echo json_encode(["success" => true, "message" => "Número registrado exitosamente."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error al registrar el número.", "error" => $conn->error]);
    }
}

// Cerrar conexión
$conn->close();

?>
