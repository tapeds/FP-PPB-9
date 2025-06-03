import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fp_ppb/models/habit.dart';
import 'package:fp_ppb/models/log.dart';
import 'package:fp_ppb/services/log_service.dart';
import 'package:fp_ppb/views/widgets/log_form_dialog.dart';

class LogScreen extends StatefulWidget {
  final Habit habit;

  const LogScreen({super.key, required this.habit});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final _logService = LogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.habit.name} Logs'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Log>>(
        stream: _logService.getLogsByHabit(widget.habit.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No logs yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add your first log',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    log.completed ? Icons.check_circle : Icons.circle_outlined,
                    color: log.completed ? Colors.green : Colors.grey,
                  ),
                  title: Text(DateFormat('d MMMM y').format(log.date)),
                  subtitle: log.notes.isNotEmpty ? Text(log.notes) : null,
                  trailing: PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditLogDialog(context, log);
                      } else if (value == 'delete') {
                        _deleteLog(context, log);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLogDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Log'),
      ),
    );
  }

  void _showAddLogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => LogFormDialog(
            habitId: widget.habit.id,
            userId: FirebaseAuth.instance.currentUser!.uid,
            onSave: (date, notes, completed) async {
              try {
                final log = Log.create(
                  habitId: widget.habit.id,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  date: date,
                  notes: notes,
                  completed: completed,
                );

                await _logService.createLog(log);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log created successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating log: $e')),
                  );
                }
              }
            },
          ),
    );
  }

  void _showEditLogDialog(BuildContext context, Log log) {
    showDialog(
      context: context,
      builder:
          (context) => LogFormDialog(
            habitId: widget.habit.id,
            userId: FirebaseAuth.instance.currentUser!.uid,
            initialLog: log,
            onSave: (date, notes, completed) async {
              try {
                final updatedLog = log.copyWith(
                  date: date,
                  notes: notes,
                  completed: completed,
                );

                await _logService.updateLog(updatedLog);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log updated successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating log: $e')),
                  );
                }
              }
            },
          ),
    );
  }

  Future<void> _deleteLog(BuildContext context, Log log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Log'),
            content: const Text('Are you sure you want to delete this log?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _logService.deleteLog(widget.habit.id, log.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting log: $e')));
        }
      }
    }
  }
}
