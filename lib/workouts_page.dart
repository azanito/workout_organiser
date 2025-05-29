import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'services/workout_service.dart';  // импорт сервиса Firebase

class WorkoutsPage extends StatefulWidget {
  final bool isOnline;
  const WorkoutsPage({required this.isOnline, super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class Workout {
  final String id;
  String title;
  String description;
  DateTime createdAt;
  DateTime? updatedAt;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final List<Workout> _workouts = [];
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isLoading = false;

  final WorkoutService _workoutService = WorkoutService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      if (widget.isOnline) {
        // Загрузка из Firebase
        final onlineData = await _workoutService.loadWorkouts();
        setState(() => _workouts
          ..clear()
          ..addAll(onlineData));
        await _saveToLocal(onlineData);
      } else {
        final localData = await _loadFromLocal();
        setState(() => _workouts
          ..clear()
          ..addAll(localData));
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Workout>> _loadFromLocal() async {
    final box = await Hive.openBox('workouts');
    final data = box.values.toList();
    return data.map((e) => Workout.fromMap(e)).toList();
  }

  Future<void> _saveToLocal(List<Workout> workouts) async {
    final box = await Hive.openBox('workouts');
    await box.clear();
    for (final workout in workouts) {
      await box.put(workout.id, workout.toMap());
    }
  }

  Future<void> _saveToFirebase(Workout workout) async {
    if (!widget.isOnline) {
      await _saveToLocal([workout]);
      return;
    }
    if (_workouts.any((w) => w.id == workout.id)) {
      await _workoutService.updateWorkout(workout);
    } else {
      await _workoutService.addWorkout(workout);
    }
  }

  void _showDialog({bool edit = false, Workout? workout}) {
    if (edit && workout != null) {
      _titleCtrl.text = workout.title;
      _descCtrl.text = workout.description;
    } else {
      _titleCtrl.clear();
      _descCtrl.clear();
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(edit ? 'Edit Workout' : 'Add Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _handleSave(edit: edit, workout: workout),
            child: Text(edit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave({required bool edit, Workout? workout}) async {
    final title = _titleCtrl.text.trim();
    final description = _descCtrl.text.trim();
    if (title.isEmpty || description.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final newWorkout = Workout(
        id: edit ? workout!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: edit ? workout!.createdAt : now,
        updatedAt: now,
      );

      if (edit) {
        await _saveToFirebase(newWorkout);
        setState(() {
          _workouts[_workouts.indexWhere((w) => w.id == workout!.id)] = newWorkout;
        });
      } else {
        await _saveToFirebase(newWorkout);
        setState(() => _workouts.add(newWorkout));
      }
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving workout: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _delete(int index) async {
    final workout = _workouts[index];
    setState(() => _isLoading = true);
    try {
      if (widget.isOnline) {
        await _workoutService.deleteWorkout(workout.id);
      }
      final box = await Hive.openBox('workouts');
      await box.delete(workout.id);
      if (mounted) {
        setState(() => _workouts.removeAt(index));
      }
    } catch (e) {
      debugPrint('Error deleting workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting workout: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDetails(Workout workout) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(workout.title),
          content: Text(workout.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
        actions: [
          if (!widget.isOnline)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_off, color: Colors.red),
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
              ? const Center(child: Text("No workouts yet"))
              : OrientationBuilder(
                  builder: (_, __) {
                    if (width < 600) {
                      return ListView.builder(
                        itemCount: _workouts.length,
                        itemBuilder: (_, i) => _WorkoutTile(
                          workout: _workouts[i],
                          onTap: () => _showDetails(_workouts[i]),
                          onLong: () => _delete(i),
                          onEdit: () => _showDialog(edit: true, workout: _workouts[i]),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _workouts.length,
                        itemBuilder: (_, i) => _WorkoutCard(
                          workout: _workouts[i],
                          onTap: () => _showDetails(_workouts[i]),
                          onLong: () => _delete(i),
                          onEdit: () => _showDialog(edit: true, workout: _workouts[i]),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;
  final VoidCallback onLong;
  final VoidCallback onEdit;

  const _WorkoutTile({
    required this.workout,
    required this.onTap,
    required this.onLong,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.title),
        subtitle: Text(workout.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(workout.updatedAt != null
                ? 'Updated: ${workout.updatedAt!.toLocal().toString().split(' ')[0]}'
                : 'Created: ${workout.createdAt.toLocal().toString().split(' ')[0]}'),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLong,
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;
  final VoidCallback onLong;
  final VoidCallback onEdit;

  const _WorkoutCard({
    required this.workout,
    required this.onTap,
    required this.onLong,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLong,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(workout.description),
              const Spacer(),
              Text(
                workout.updatedAt != null
                    ? 'Updated: ${workout.updatedAt!.toLocal().toString().split(' ')[0]}'
                    : 'Created: ${workout.createdAt.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
