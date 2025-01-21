import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedData;
  Map<String, dynamic>? studentData;
  String? message;
  Color messageColor = Colors.black;
  bool isLoading = false;

  void validateQR(String qrData) async {
    const baseUrl = "https://tu-cede.mindbox.app/validate-cr/";
    if (qrData.contains(baseUrl)) {
      String remainingText = qrData.replaceFirst(baseUrl, "");
      setState(() {
        isLoading = true;
      });
      await fetchStudentData(remainingText);
    } else {
      setState(() {
        message = "Credencial no válida";
        messageColor = Colors.red;
        isLoading = false;
      });
    }
  }

  Future<void> fetchStudentData(String remainingText) async {
    final apiUrl =
        "https:/tu-link.com/api_datos_credencial.php?qr_data=$remainingText";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          studentData = data;
          message = "Datos del alumno";
          messageColor = Colors.black;
        });
      } else {
        setState(() {
          message = "Error al consultar los datos del alumno.";
          messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        message = "Error al consultar la API.";
        messageColor = Colors.red;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerStudent(String controlNumber) async {
    final apiUrl =
        "https:/tu-link.com/api_numero_control.php?num=$controlNumber";

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          setState(() {
            message = "Alumno registrado, da aguinaldo";
            messageColor = Colors.green;
          });
        } else {
          setState(() {
            message = "Este alumno ya recibió su aguinaldo";
            messageColor = Colors.red;
          });
        }
      } else {
        setState(() {
          message = "Error al registrar al alumno.";
          messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        message = "Error al consultar la API de registro.";
        messageColor = Colors.red;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner de QR'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) {
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  validateQR(code);
                }
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Cargando información...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          if (!isLoading && message != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: messageColor,
                ),
              ),
            ),
          if (!isLoading && studentData != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Nombre: ${studentData!['name']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Matrícula: ${studentData!['matricula']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "CURP: ${studentData!['curp']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Grado: ${studentData!['grado']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Plan de estudios: ${studentData!['plan_estudios']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Vigencia: ${studentData!['vigencia']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final controlNumber = studentData!['matricula'].trim();
                      registerStudent(controlNumber);
                    },
                    child: Text("Registrar"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
