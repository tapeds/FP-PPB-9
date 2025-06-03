import 'package:flutter/material.dart';
import 'package:fp_ppb/models/habit.dart';
import 'package:fp_ppb/services/habit_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Might be needed for user ID
import 'dart:async'; // For StreamSubscription

class HabitsViewModel extends ChangeNotifier {
  final HabitService _habitService = HabitService();

  StreamSubscription<List<Habit>>? _habitsSubscription;
  List<Habit> _allHabits = [];
  List<Habit> _todayHabits = [];

  List<Habit> get allHabits => _allHabits;
  List<Habit> get todayHabits => _todayHabits;

  HabitsViewModel() {
    _fetchHabits();
  }

  void _fetchHabits() {
    _habitsSubscription?.cancel(); // Cancel previous subscription
    _habitsSubscription = _habitService.getHabits().listen((habits) {
      _allHabits = habits;
      _filterTodayHabits();
      notifyListeners();
    });
  }

  void _filterTodayHabits() {
    final now = DateTime.now();
    final dayIndex = (now.weekday - 1) % 7; // 0 = Monday, 6 = Sunday
    _todayHabits =
        _allHabits
            .where(
              (habit) =>
                  habit.schedule.length > dayIndex && habit.schedule[dayIndex],
            )
            .toList();
  }

  Future<void> createHabit(
    String name,
    String description,
    List<bool> schedule,
    TimeOfDay reminderTime,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final habit = Habit.create(
      name: name,
      description: description,
      schedule: schedule,
      reminderTime: reminderTime,
      userId: userId,
    );
    await _habitService.createHabit(habit);
    // No need to re-fetch or notifyListeners here, the stream listener handles updates.
  }

  Future<void> updateHabit(
    Habit habit,
    String name,
    String description,
    List<bool> schedule,
    TimeOfDay reminderTime,
  ) async {
    final updatedHabit = habit.copyWith(
      name: name,
      description: description,
      schedule: schedule,
      reminderTime: reminderTime,
    );
    await _habitService.updateHabit(updatedHabit);
    // No need to re-fetch or notifyListeners here, the stream listener handles updates.
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitService.deleteHabit(habitId);
    // No need to re-fetch or notifyListeners here, the stream listener handles updates.
  }

  // TODO: Implement habit completion toggle
  void toggleHabitCompletion(Habit habit) {
    // Logic to update habit completion status and potentially streak
    notifyListeners(); // Notify listeners after updating state
  }

  @override
  void dispose() {
    _habitsSubscription?.cancel();
    super.dispose();
  }
}
