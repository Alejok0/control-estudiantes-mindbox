<?php

header('Content-Type: application/json');

// URL base del QR (URL corregida)
$base_url = "https://tu-cede.mindbox.app/validate-cr/";

// Obtener parámetro dinámico desde la URL (ejemplo: ?qr_data=...)
if (!isset($_GET['qr_data']) || empty($_GET['qr_data'])) {
    echo json_encode(['error' => 'Falta el parámetro qr_data'], JSON_PRETTY_PRINT);
    exit;
}

$qr_data = $_GET['qr_data']; // Parámetro dinámico
$url = $base_url . $qr_data;

// Función para hacer la solicitud HTTP
function fetch_data_from_url($url) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
    ]);
    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        return ['error' => curl_error($ch)];
    }
    curl_close($ch);
    return $response;
}

// Obtener el contenido de la página
$html_content = fetch_data_from_url($url);

// Verificar si la página no fue encontrada (404)
if (str_contains($html_content, '404')) {
    echo json_encode(['error' => 'Página no encontrada (404). Verifica la URL o el parámetro qr_data.'], JSON_PRETTY_PRINT);
    exit;
}

// Guardar HTML para depuración (opcional)
file_put_contents('debug.html', $html_content);

// Función para extraer los datos del estudiante
function extract_student_data($html) {
    $data = [];

    // Extraer nombre completo
    preg_match('/<span\s+class="text-mb-primary font-bold">(.*?)<\/span>/', $html, $matches);
    $data['name'] = $matches[1] ?? null;

    // Extraer matrícula
    preg_match('/<span\s+class="text-mb-accent font-bold">Matrícula:\s*(.*?)<\/span>/', $html, $matches);
    $data['matricula'] = $matches[1] ?? null;

    // Extraer CURP
    preg_match('/<span>CURP:\s*(.*?)<\/span>/', $html, $matches);
    $data['curp'] = $matches[1] ?? null;

    // Extraer grado
    preg_match('/<span>Grado:\s*(.*?)<\/span>/', $html, $matches);
    $data['grado'] = $matches[1] ?? null;

    // Extraer plan de estudios
    preg_match('/<span>Plan de estudios:\s*(.*?)<\/span>/', $html, $matches);
    $data['plan_estudios'] = $matches[1] ?? null;

    // Extraer vigencia
    preg_match('/<i\s+class="fa fa-check-circle text-green-500"><\/i>\s*(.*?)<\/span>/', $html, $matches);
    $data['vigencia'] = trim($matches[1] ?? '');

    // Extraer cadena digital
    preg_match('/<span\s+class="font-bold">Cadena digital:<\/span>\s*<span>(.*?)<\/span>/', $html, $matches);
    $data['cadena_digital'] = $matches[1] ?? null;

    return $data;
}

// Extraer los datos del estudiante
$student_data = extract_student_data($html_content);
echo json_encode($student_data, JSON_PRETTY_PRINT);

?>
