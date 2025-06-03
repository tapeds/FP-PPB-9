import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb/models/habit.dart';

class HabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the habits collection reference for the current user
  CollectionReference<Map<String, dynamic>> get _habitsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(userId).collection('habits');
  }

  // Stream of habits for the current user
  Stream<List<Habit>> getHabits() {
    return _habitsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
        });
  }

  // Create a new habit
  Future<Habit> createHabit(Habit habit) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final docRef = await _habitsCollection.add(habit.toFirestore());
    return habit.copyWith(id: docRef.id);
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    await _habitsCollection.doc(habit.id).update(habit.toFirestore());
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    await _habitsCollection.doc(habitId).delete();
  }

  // Update habit streak
  Future<void> updateStreak(String habitId, int newStreak) async {
    await _habitsCollection.doc(habitId).update({
      'streak': newStreak,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get habits for a specific day of the week (0 = Monday, 6 = Sunday)
  // This method will now fetch all habits, filtering will be done in the ViewModel
  Stream<List<Habit>> getHabitsForDay(int dayIndex) {
    return _habitsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
        });
  }
}
