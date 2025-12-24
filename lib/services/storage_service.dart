import 'package:shared_preferences/shared_preferences.dart';
import 'firestore_service.dart';

class StorageService {
  static const String _keyPickedNumbers = 'picked_numbers';
  final FirestoreService _firestoreService = FirestoreService();

  /// Guardar la lista de números que ya han salido (usa Firestore si hay usuario)
  Future<void> savePickedNumbers(List<int> pickedNumbers,
      {String? userId, required int totalSaved}) async {
    if (userId != null) {
      // Guardar en Firestore si hay usuario autenticado
      await _firestoreService.savePickedNumbers(userId, pickedNumbers,
          totalSaved: totalSaved);
    } else {
      // Fallback a SharedPreferences si no hay usuario (compatibilidad)
      final prefs = await SharedPreferences.getInstance();
      List<String> stringList = pickedNumbers.map((e) => e.toString()).toList();
      await prefs.setStringList(_keyPickedNumbers, stringList);
    }
  }

  /// Recuperar la lista de números guardados
  Future<List<int>> getPickedNumbers({String? userId}) async {
    if (userId != null) {
      // Obtener de Firestore si hay usuario
      final progress = await _firestoreService.getUserProgress(userId);
      return progress?.pickedNumbers ?? [];
    } else {
      // Fallback a SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String>? stringList = prefs.getStringList(_keyPickedNumbers);

      if (stringList == null) {
        return [];
      }

      return stringList.map((e) => int.parse(e)).toList();
    }
  }

  /// Obtener stream de progreso (solo para usuarios autenticados)
  Stream<List<int>> getPickedNumbersStream(String userId) {
    return _firestoreService.getUserProgressStream(userId).map((progress) {
      return progress?.pickedNumbers ?? [];
    });
  }

  /// Agregar un número de forma atómica
  Future<void> addPickedNumber(int number,
      {String? userId, required int totalSaved}) async {
    if (userId != null) {
      await _firestoreService.addPickedNumber(userId, number,
          totalSaved: totalSaved);
    } else {
      // Fallback local
      final current = await getPickedNumbers();
      if (!current.contains(number)) {
        current.add(number);
        await savePickedNumbers(current, totalSaved: totalSaved);
      }
    }
  }

  /// Reiniciar todo el progreso
  Future<void> clearProgress({String? userId}) async {
    if (userId != null) {
      await _firestoreService.clearProgress(userId);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyPickedNumbers);
    }
  }

  /// Migrar datos locales a Firestore cuando el usuario inicia sesión
  Future<void> migrateToFirestore(String userId, int totalSaved) async {
    // Obtener datos locales
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList(_keyPickedNumbers);

    if (stringList != null && stringList.isNotEmpty) {
      List<int> localNumbers = stringList.map((e) => int.parse(e)).toList();
      await _firestoreService.migrateLocalData(userId, localNumbers,
          totalSaved: totalSaved);

      // Limpiar datos locales después de migrar
      await prefs.remove(_keyPickedNumbers);
    }
  }
}

