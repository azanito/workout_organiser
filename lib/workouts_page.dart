import 'package:flutter/material.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _Workout {
  String title;
  String description;

  _Workout({required this.title, required this.description});
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final List<_Workout> _workouts = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  int? _selectedWorkoutIndex;

  void _showAddWorkoutDialog({bool isEdit = false}) {
    if (isEdit && _selectedWorkoutIndex != null) {
      final workout = _workouts[_selectedWorkoutIndex!];
      _titleController.text = workout.title;
      _descController.text = workout.description;
    } else {
      _titleController.clear();
      _descController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Workout' : 'Add Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEdit && _selectedWorkoutIndex != null) {
                  _workouts[_selectedWorkoutIndex!] = _Workout(
                    title: _titleController.text,
                    description: _descController.text,
                  );
                } else {
                  _workouts.add(_Workout(
                    title: _titleController.text,
                    description: _descController.text,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: Text(isEdit ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  void _showWorkoutDetails(_Workout workout) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(workout.title),
        content: Text(workout.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Organizer"),
        backgroundColor: Colors.green.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddWorkoutDialog(),
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return _workouts.isEmpty
              ? const Center(child: Text("No workouts yet. Add one!"))
              : screenWidth < 600
                  ? ListView.builder(
                      itemCount: _workouts.length,
                      itemBuilder: (_, index) {
                        final workout = _workouts[index];
                        return GestureDetector(
                          onTap: () => _showWorkoutDetails(workout),
                          onLongPress: () => _deleteWorkout(index),
                          child: Card(
                            child: ListTile(
                              title: Text(workout.title),
                              subtitle: Text(workout.description),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _selectedWorkoutIndex = index;
                                  _showAddWorkoutDialog(isEdit: true);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _workouts.length,
                      itemBuilder: (_, index) {
                        final workout = _workouts[index];
                        return GestureDetector(
                          onTap: () => _showWorkoutDetails(workout),
                          onLongPress: () => _deleteWorkout(index),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    workout.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(workout.description),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _selectedWorkoutIndex = index;
                                      _showAddWorkoutDialog(isEdit: true);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
