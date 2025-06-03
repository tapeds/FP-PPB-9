import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fp_ppb/models/log.dart';

class LogFormDialog extends StatefulWidget {
  final String habitId;
  final String userId;
  final Log? initialLog;
  final Function(DateTime date, String notes, bool completed) onSave;

  const LogFormDialog({
    super.key,
    required this.habitId,
    required this.userId,
    required this.onSave,
    this.initialLog,
  });

  @override
  State<LogFormDialog> createState() => _LogFormDialogState();
}

class _LogFormDialogState extends State<LogFormDialog> {
  late DateTime _selectedDate;
  late TextEditingController _notesController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialLog?.date ?? DateTime.now();
    _notesController = TextEditingController(
      text: widget.initialLog?.notes ?? '',
    );
    _completed = widget.initialLog?.completed ?? true;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialLog == null ? 'Add Log' : 'Edit Log'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(DateFormat('d MMMM y').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Completed'),
              value: _completed,
              onChanged: (value) => setState(() => _completed = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_selectedDate, _notesController.text, _completed);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
