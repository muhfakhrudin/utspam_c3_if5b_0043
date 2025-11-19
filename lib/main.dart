import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Mobil App',
      theme: ThemeData(
        // Tema Warna Biru Profesional (Indigo)
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Latar abu-abu sangat muda (Modern)
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text("Setup Awal"))),
    );
  }
}
