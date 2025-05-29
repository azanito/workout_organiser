import 'package:cloud_firestore/cloud_firestore.dart';
import '../workouts_page.dart'; // Импорт модели Workout

class WorkoutService {
  final CollectionReference _workoutsRef =
      FirebaseFirestore.instance.collection('workouts');

  Future<void> addWorkout(Workout workout) async {
    final docRef = await _workoutsRef.add(workout.toMap());
    // Обновим id с firestore doc id
    await docRef.update({'id': docRef.id});
  }

  Future<void> updateWorkout(Workout workout) async {
    await _workoutsRef.doc(workout.id).update(workout.toMap());
  }

  Future<void> deleteWorkout(String id) async {
    await _workoutsRef.doc(id).delete();
  }

  Stream<List<Workout>> getWorkoutsStream() {
    return _workoutsRef.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Workout.fromMap(data);
        }).toList();
      },
    );
  }

  loadWorkouts() {}
}
