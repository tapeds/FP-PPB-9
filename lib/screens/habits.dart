import 'package:flutter/material.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits'), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHabitCategories(),
                  const SizedBox(height: 24),
                  _buildHabitsList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddHabitDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }

  Widget _buildHabitCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('All', true),
              _buildCategoryChip('Health', false),
              _buildCategoryChip('Productivity', false),
              _buildCategoryChip('Mindfulness', false),
              _buildCategoryChip('Learning', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // TODO: Implement category filtering
        },
      ),
    );
  }

  Widget _buildHabitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement sort options
              },
              icon: const Icon(Icons.sort),
              label: const Text('Sort'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            // Example schedule data
            final schedule =
                index % 3 == 0
                    ? 'Daily'
                    : index % 3 == 1
                    ? 'Mon, Wed, Fri'
                    : 'Weekends';
            final time = '${8 + (index % 3)}:00 AM';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                leading: Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey[600],
                ),
                title: Text('Habit ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category ${index % 3 + 1}'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          schedule,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(index + 1) * 20}%',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildHabitDetail('Frequency', schedule),
                        _buildHabitDetail('Reminder', time),
                        _buildHabitDetail('Streak', '${index + 3} days'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                _showEditHabitDialog(context, index);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                // TODO: Implement delete habit
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Habit'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Habit Name',
                      hintText: 'e.g., Morning Meditation',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your habit...',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'health', child: Text('Health')),
                      DropdownMenuItem(
                        value: 'productivity',
                        child: Text('Productivity'),
                      ),
                      DropdownMenuItem(
                        value: 'mindfulness',
                        child: Text('Mindfulness'),
                      ),
                      DropdownMenuItem(
                        value: 'learning',
                        child: Text('Learning'),
                      ),
                    ],
                    onChanged: (value) {
                      // TODO: Implement category selection
                    },
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
                  // TODO: Implement save habit
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showEditHabitDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Habit'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Habit Name',
                      hintText: 'e.g., Morning Meditation',
                    ),
                    controller: TextEditingController(
                      text: 'Habit ${index + 1}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your habit...',
                    ),
                    maxLines: 2,
                    controller: TextEditingController(
                      text: 'Description for habit ${index + 1}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: 'category_${index % 3 + 1}',
                    items: const [
                      DropdownMenuItem(
                        value: 'category_1',
                        child: Text('Category 1'),
                      ),
                      DropdownMenuItem(
                        value: 'category_2',
                        child: Text('Category 2'),
                      ),
                      DropdownMenuItem(
                        value: 'category_3',
                        child: Text('Category 3'),
                      ),
                    ],
                    onChanged: (value) {
                      // TODO: Implement category selection
                    },
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
                  // TODO: Implement update habit
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
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
            _buildDayChip('Mon', true),
            _buildDayChip('Tue', false),
            _buildDayChip('Wed', true),
            _buildDayChip('Thu', false),
            _buildDayChip('Fri', true),
            _buildDayChip('Sat', false),
            _buildDayChip('Sun', false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement quick schedule selection
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Quick Schedule'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement custom schedule
                },
                icon: const Icon(Icons.edit_calendar),
                label: const Text('Custom'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayChip(String day, bool isSelected) {
    return FilterChip(
      label: Text(day),
      selected: isSelected,
      onSelected: (bool selected) {
        // TODO: Implement day selection
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
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Hour',
                  isDense: true,
                ),
                value: '8',
                items: List.generate(
                  24,
                  (index) => DropdownMenuItem(
                    value: index.toString(),
                    child: Text('${index.toString().padLeft(2, '0')}'),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement hour selection
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Minute',
                  isDense: true,
                ),
                value: '00',
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem(
                    value: (index * 5).toString().padLeft(2, '0'),
                    child: Text('${(index * 5).toString().padLeft(2, '0')}'),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement minute selection
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'AM/PM',
                  isDense: true,
                ),
                value: 'AM',
                items: const [
                  DropdownMenuItem(value: 'AM', child: Text('AM')),
                  DropdownMenuItem(value: 'PM', child: Text('PM')),
                ],
                onChanged: (value) {
                  // TODO: Implement AM/PM selection
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
