import 'package:flutter/material.dart';
import 'qr_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rgistrar estudiante',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScannerScreen(),
    );
  }
}
