# Proyecto de Registro y Validación de Estudiantes

Este repositorio contiene tres componentes principales: una API REST desarrollada en PHP, una aplicación móvil creada con Flutter y una base de datos para almacenar la información de los estudiantes.

## Estructura del Repositorio

- **API REST**: Proporciona los endpoints necesarios para la validación y el registro de estudiantes.
- **Aplicación Móvil**: Una app que permite escanear códigos QR, validar credenciales y registrar estudiantes.
- **Base de Datos**: Diseño y configuración para almacenar la información de los estudiantes.

---

## Requisitos Previos

- **Servidor Web**: Recomendado [XAMPP](https://www.apachefriends.org/) o [WAMP](https://www.wampserver.com/).
- **PHP**: Versión 7.4 o superior.
- **MySQL**: Versión 5.7 o superior.
- **Flutter**: Última versión estable.
- **Composer**: Para gestionar dependencias de PHP.
- **Android Studio o Xcode**: Para la compilación y ejecución de la aplicación móvil.

---

## Instalación

### 1. Configuración de la Base de Datos

1. Crea una base de datos llamada `control-mindbox`.
2. Importa el archivo `control-mindbox.sql` incluido en el repositorio a través de phpMyAdmin u otra herramienta de gestión de bases de datos.

```bash
# Importación con MySQL
mysql -u root -p control-mindbox < control-mindbox.sql
```

### 2. Configuración de la API REST

1. Coloca los archivos PHP de la API en el directorio raíz de tu servidor web (por ejemplo, `htdocs` para XAMPP).
2. Modifica las credenciales de la base de datos en los scripts PHP (`api_numero_control.php` y `api_datos_credencial.php`):

```php
$db_host = "localhost";
$db_user = "root";
$db_pass = "tu_contraseña";
$db_name = "control-mindbox";
```

3. Verifica que el servidor tenga habilitada la extensión `cURL` de PHP.

### 3. Configuración de la Aplicación Móvil

1. Asegúrate de tener Flutter instalado y configurado.
2. Abre el directorio de la app móvil en tu IDE (Android Studio o VS Code).
3. Modifica el archivo `QRScannerScreen.dart` para apuntar a tu API:

```dart
const baseUrl = "https://tu-servidor.com/";
```

4. Ejecuta la app en un dispositivo o emulador:

```bash
flutter run
```

---

## Endpoints de la API REST

### Registro de Estudiantes

**URL**: `/api_numero_control.php`

**Método**: `GET`

**Parámetros**:
- `num` (string): Número de control del estudiante.

**Respuesta**:
```json
{
  "success": true,
  "message": "Número registrado exitosamente."
}
```

---

### Validación de Credenciales

**URL**: `/api_datos_credencial.php`

**Método**: `GET`

**Parámetros**:
- `qr_data` (string): Información del código QR.

**Respuesta**:
```json
{
  "name": "Juan Pérez",
  "matricula": "12345678",
  "curp": "CURP1234567890",
  "grado": "1",
  "plan_estudios": "Octavo",
  "vigencia": "2025-12-31",
  "cadena_digital": "ABCDEF123456"
}
```

---

## Uso de la Aplicación Móvil

1. Abre la aplicación en tu dispositivo.
2. Escanea el código QR de un estudiante.
3. Valida la credencial y, si es correcta, registra al estudiante para otorgar beneficios.

---

## Licencia

Este proyecto está bajo la Licencia GNU GENERAL PUBLIC LICENSE. Consulta el archivo `LICENSE` para más detalles.
