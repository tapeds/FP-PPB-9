import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final String notes;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Log({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.notes,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Log.create({
    required String habitId,
    required String userId,
    required DateTime date,
    String notes = '',
    bool completed = true,
  }) {
    final now = DateTime.now();
    return Log(
      id: '', // Will be set by Firestore
      habitId: habitId,
      userId: userId,
      date: date,
      notes: notes,
      completed: completed,
      createdAt: now,
      updatedAt: now,
    );
  }

  Log copyWith({
    String? id,
    String? habitId,
    String? userId,
    DateTime? date,
    String? notes,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Log(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'completed': completed,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Log.fromMap(String id, Map<String, dynamic> map) {
    return Log(
      id: id,
      habitId: map['habitId'] as String,
      userId: map['userId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      notes: map['notes'] as String,
      completed: map['completed'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
