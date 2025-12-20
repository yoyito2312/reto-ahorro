import 'dart:math';

class GameLogic {
  // Total de días del reto
  static const int totalDays = 365;
  
  // Valor base multiplicador (ej: dia 1 * 100 = 100)
  static const int multiplier = 100;

  // Calcula el total ahorrado sumando todos los números seleccionados * multiplicador
  int calculateTotalSaved(List<int> pickedNumbers) {
    int sum = 0;
    for (var n in pickedNumbers) {
      sum += n;
    }
    return sum * multiplier;
  }

  // Calcula cuántos días faltan
  int calculateDaysLeft(List<int> pickedNumbers) {
    return totalDays - pickedNumbers.length;
  }

  // Obtiene la lista de números disponibles (los que no están en pickedNumbers)
  List<int> getAvailableNumbers(List<int> pickedNumbers) {
    List<int> allNumbers = List.generate(totalDays, (index) => index + 1);
    // Filtramos para dejar solo los que NO están en pickedNumbers
    return allNumbers.where((n) => !pickedNumbers.contains(n)).toList();
  }

  // Genera un número aleatorio de los disponibles
  // Retorna null si ya no hay números (reto completado)
  int? generateRandomNumber(List<int> pickedNumbers) {
    List<int> available = getAvailableNumbers(pickedNumbers);
    
    if (available.isEmpty) {
      return null;
    }

    int randomIndex = Random().nextInt(available.length);
    return available[randomIndex];
  }
  
  // Calcular el total teórico máximo (meta)
  int calculateTargetTotal() {
    // Suma de gauss: n(n+1)/2 -> 365*366/2 = 66795
    // Multiplicado por 100 -> 6,679,500
    int sum = (totalDays * (totalDays + 1)) ~/ 2;
    return sum * multiplier;
  }
}
