import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  // NOTA: Necesitarás configurar Firebase para cada plataforma
  // antes de que esto funcione correctamente
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD87z0BqMhO3RaYD7YYaQeZdSkk3HIo5ZE',
        appId: '1:630529257280:web:c2df2f49ac5c36927754a5',
        messagingSenderId: '630529257280',
        projectId: 'reto-ahorro',
        authDomain: 'reto-ahorro.firebaseapp.com',
        storageBucket: 'reto-ahorro.firebasestorage.app',
      ),
    );
  } catch (e) {
    // Error al inicializar Firebase
    print('Error inicializando Firebase: $e');
  }
  
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
      home: const AuthWrapper(),
    );
  }
}

/// Widget que decide entre mostrar login o home según el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mientras carga el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si hay usuario autenticado, mostrar HomeScreen
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Si no hay usuario, mostrar AuthScreen
        return const AuthScreen();
      },
    );
  }
}
