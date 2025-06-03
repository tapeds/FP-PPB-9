import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final List<bool> schedule; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  final TimeOfDay reminderTime;
  final int streak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.schedule,
    required this.reminderTime,
    this.streak = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  // Create a new habit
  factory Habit.create({
    required String name,
    required String description,
    required List<bool> schedule,
    required TimeOfDay reminderTime,
    required String userId,
  }) {
    final now = DateTime.now();
    return Habit(
      id: '', // Will be set when saved to Firestore
      name: name,
      description: description,
      schedule: schedule,
      reminderTime: reminderTime,
      streak: 0,
      createdAt: now,
      updatedAt: now,
      userId: userId,
    );
  }

  // Convert Firestore document to Habit object
  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final reminderTimeData = data['reminderTime'] as Map<String, dynamic>;

    return Habit(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String,
      schedule: List<bool>.from(data['schedule'] as List),
      reminderTime: TimeOfDay(
        hour: reminderTimeData['hour'] as int,
        minute: reminderTimeData['minute'] as int,
      ),
      streak: data['streak'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'] as String,
    );
  }

  // Convert Habit object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'schedule': schedule,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'streak': streak,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
    };
  }

  // Create a copy of the habit with updated fields
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    List<bool>? schedule,
    TimeOfDay? reminderTime,
    int? streak,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
      reminderTime: reminderTime ?? this.reminderTime,
      streak: streak ?? this.streak,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      userId: userId,
    );
  }
}
