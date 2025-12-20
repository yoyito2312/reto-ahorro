import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyPickedNumbers = 'picked_numbers';

  // Guardar la lista de números que ya han salido
  Future<void> savePickedNumbers(List<int> pickedNumbers) async {
    final prefs = await SharedPreferences.getInstance();
    // Convertimos la lista de enteros a lista de strings para guardarla
    List<String> stringList = pickedNumbers.map((e) => e.toString()).toList();
    await prefs.setStringList(_keyPickedNumbers, stringList);
  }

  // Recuperar la lista de números guardados
  Future<List<int>> getPickedNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList(_keyPickedNumbers);

    if (stringList == null) {
      return [];
    }

    return stringList.map((e) => int.parse(e)).toList();
  }

  // Reiniciar todo el progreso (para pruebas o reiniciar reto)
  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPickedNumbers);
  }
}
