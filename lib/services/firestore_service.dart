import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos del progreso del usuario
class UserProgress {
  final String userId;
  final List<int> pickedNumbers;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final int totalSaved;
  final int daysCompleted;

  UserProgress({
    required this.userId,
    required this.pickedNumbers,
    required this.createdAt,
    required this.lastUpdated,
    required this.totalSaved,
    required this.daysCompleted,
  });

  /// Crear desde un documento de Firestore
  factory UserProgress.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProgress(
      userId: doc.id,
      pickedNumbers: List<int>.from(data['pickedNumbers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      totalSaved: data['totalSaved'] ?? 0,
      daysCompleted: data['daysCompleted'] ?? 0,
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'pickedNumbers': pickedNumbers,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'totalSaved': totalSaved,
      'daysCompleted': daysCompleted,
    };
  }
}

/// Servicio para manejar operaciones de Firestore
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Referencia a la colección de progreso de usuarios
  CollectionReference get _progressCollection =>
      _firestore.collection('user_progress');

  /// Obtener el progreso del usuario (listener en tiempo real)
  Stream<UserProgress?> getUserProgressStream(String userId) {
    return _progressCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProgress.fromFirestore(doc);
    });
  }

  /// Obtener el progreso del usuario (una sola vez)
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      DocumentSnapshot doc = await _progressCollection.doc(userId).get();
      if (!doc.exists) return null;
      return UserProgress.fromFirestore(doc);
    } catch (e) {
      throw 'Error al obtener progreso: $e';
    }
  }

  /// Guardar números seleccionados del usuario
  Future<void> savePickedNumbers(String userId, List<int> pickedNumbers,
      {required int totalSaved}) async {
    try {
      final docRef = _progressCollection.doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        // Actualizar documento existente
        await docRef.update({
          'pickedNumbers': pickedNumbers,
          'lastUpdated': FieldValue.serverTimestamp(),
          'totalSaved': totalSaved,
          'daysCompleted': pickedNumbers.length,
        });
      } else {
        // Crear nuevo documento
        await docRef.set({
          'pickedNumbers': pickedNumbers,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
          'totalSaved': totalSaved,
          'daysCompleted': pickedNumbers.length,
        });
      }
    } catch (e) {
      throw 'Error al guardar progreso: $e';
    }
  }

  /// Agregar un número a la lista del usuario (transacción atómica)
  Future<void> addPickedNumber(String userId, int number,
      {required int totalSaved}) async {
    try {
      final docRef = _progressCollection.doc(userId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot doc = await transaction.get(docRef);

        List<int> currentNumbers = [];
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          currentNumbers = List<int>.from(data['pickedNumbers'] ?? []);
        }

        // Agregar el nuevo número si no existe ya
        if (!currentNumbers.contains(number)) {
          currentNumbers.add(number);

          if (doc.exists) {
            transaction.update(docRef, {
              'pickedNumbers': currentNumbers,
              'lastUpdated': FieldValue.serverTimestamp(),
              'totalSaved': totalSaved,
              'daysCompleted': currentNumbers.length,
            });
          } else {
            transaction.set(docRef, {
              'pickedNumbers': currentNumbers,
              'createdAt': FieldValue.serverTimestamp(),
              'lastUpdated': FieldValue.serverTimestamp(),
              'totalSaved': totalSaved,
              'daysCompleted': currentNumbers.length,
            });
          }
        }
      });
    } catch (e) {
      throw 'Error al agregar número: $e';
    }
  }

  /// Reiniciar todo el progreso del usuario
  Future<void> clearProgress(String userId) async {
    try {
      await _progressCollection.doc(userId).update({
        'pickedNumbers': [],
        'lastUpdated': FieldValue.serverTimestamp(),
        'totalSaved': 0,
        'daysCompleted': 0,
      });
    } catch (e) {
      throw 'Error al reiniciar progreso: $e';
    }
  }

  /// Eliminar completamente el progreso del usuario
  Future<void> deleteProgress(String userId) async {
    try {
      await _progressCollection.doc(userId).delete();
    } catch (e) {
      throw 'Error al eliminar progreso: $e';
    }
  }

  /// Migrar datos de SharedPreferences a Firestore
  Future<void> migrateLocalData(String userId, List<int> localPickedNumbers,
      {required int totalSaved}) async {
    try {
      // Solo migrar si no hay datos en Firestore
      final existing = await getUserProgress(userId);
      if (existing == null && localPickedNumbers.isNotEmpty) {
        await savePickedNumbers(userId, localPickedNumbers,
            totalSaved: totalSaved);
      }
    } catch (e) {
      throw 'Error al migrar datos: $e';
    }
  }
}
