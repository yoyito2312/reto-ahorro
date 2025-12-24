import 'package:firebase_auth/firebase_auth.dart';

/// Servicio para manejar autenticación de usuarios con Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream que notifica cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actualmente autenticado (null si no hay sesión)
  User? get currentUser => _auth.currentUser;

  /// Registrar un nuevo usuario con email y contraseña
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el nombre para mostrar del usuario
      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error inesperado durante el registro: $e';
    }
  }

  /// Iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error inesperado durante el inicio de sesión: $e';
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error al cerrar sesión: $e';
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al enviar email de recuperación: $e';
    }
  }

  /// Actualizar el nombre para mostrar del usuario
  Future<void> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.reload();
    } catch (e) {
      throw 'Error al actualizar el nombre: $e';
    }
  }

  /// Eliminar la cuenta del usuario actual
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al eliminar la cuenta: $e';
    }
  }

  /// Traduce los errores de Firebase a mensajes en español
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este email ya está registrado. Intenta iniciar sesión.';
      case 'invalid-email':
        return 'El email no es válido.';
      case 'user-not-found':
        return 'No se encontró ninguna cuenta con este email.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde.';
      case 'operation-not-allowed':
        return 'Operación no permitida. Contacta al administrador.';
      case 'requires-recent-login':
        return 'Por seguridad, debes volver a iniciar sesión.';
      default:
        return 'Error de autenticación: ${e.message ?? e.code}';
    }
  }
}
