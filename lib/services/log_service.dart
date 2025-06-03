import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb/models/log.dart';

class LogService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Log>> getLogsByHabit(String habitId) {
    return _db
        .collection('habits')
        .doc(habitId)
        .collection('logs')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Log.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  Future<void> createLog(Log log) async {
    await _db
        .collection('habits')
        .doc(log.habitId)
        .collection('logs')
        .add(log.toMap());
  }

  Future<void> updateLog(Log log) async {
    await _db
        .collection('habits')
        .doc(log.habitId)
        .collection('logs')
        .doc(log.id)
        .update({...log.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteLog(String habitId, String logId) async {
    await _db
        .collection('habits')
        .doc(habitId)
        .collection('logs')
        .doc(logId)
        .delete();
  }
}
