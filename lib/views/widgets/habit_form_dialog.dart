import 'package:flutter/material.dart';

class HabitFormDialog extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final List<bool>? initialSchedule;
  final TimeOfDay? initialReminderTime;
  final Future<void> Function(
    String name,
    String description,
    List<bool> schedule,
    TimeOfDay reminderTime,
  )
  onSave;

  const HabitFormDialog({
    super.key,
    this.initialName,
    this.initialDescription,
    this.initialSchedule,
    this.initialReminderTime,
    required this.onSave,
  });

  @override
  State<HabitFormDialog> createState() => _HabitFormDialogState();
}

class _HabitFormDialogState extends State<HabitFormDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late List<bool> _selectedDays;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _selectedDays = List.from(widget.initialSchedule ?? List.filled(7, false));
    _selectedTime =
        widget.initialReminderTime ?? const TimeOfDay(hour: 8, minute: 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Add New Habit' : 'Edit Habit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g., Morning Meditation',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your habit...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildScheduleSelector(),
            const SizedBox(height: 16),
            _buildTimeSelector(),
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
            if (_nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a habit name')),
              );
              return;
            }

            if (!_selectedDays.contains(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one day')),
              );
              return;
            }

            widget.onSave(
              _nameController.text,
              _descriptionController.text,
              List.from(_selectedDays),
              _selectedTime,
            );
          },
          child: Text(widget.initialName == null ? 'Save' : 'Update'),
        ),
      ],
    );
  }

  Widget _buildScheduleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDayChip('Mon', 0),
            _buildDayChip('Tue', 1),
            _buildDayChip('Wed', 2),
            _buildDayChip('Thu', 3),
            _buildDayChip('Fri', 4),
            _buildDayChip('Sat', 5),
            _buildDayChip('Sun', 6),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDayChip(String day, int index) {
    return FilterChip(
      label: Text(day),
      selected: _selectedDays[index],
      onSelected: (bool selected) {
        setState(() {
          _selectedDays[index] = selected;
        });
      },
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reminder Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Hour',
                  isDense: true,
                ),
                value: _selectedTime.hour,
                items: List.generate(
                  24,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text('${index.toString().padLeft(2, '0')}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: value,
                        minute: _selectedTime.minute,
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Minute',
                  isDense: true,
                ),
                value: _selectedTime.minute,
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem(
                    value: index * 5,
                    child: Text('${(index * 5).toString().padLeft(2, '0')}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: _selectedTime.hour,
                        minute: value,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
