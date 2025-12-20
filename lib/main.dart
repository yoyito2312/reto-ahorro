import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RetoAhorroApp());
}

class RetoAhorroApp extends StatelessWidget {
  const RetoAhorroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reto Ahorro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}
