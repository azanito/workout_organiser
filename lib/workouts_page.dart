import 'package:flutter/material.dart';
import 'l10n/s.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});
  @override State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _Workout {
  String title, description;
  _Workout({required this.title, required this.description});
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final _workouts = <_Workout>[];
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  int? _editIndex;

  void _showDialog({bool edit = false}) {
    if (edit && _editIndex != null) {
      _titleCtrl.text = _workouts[_editIndex!].title;
      _descCtrl.text  = _workouts[_editIndex!].description;
    } else {
      _titleCtrl.clear();
      _descCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(edit ? S.of(context)!.editWorkout   // ← !
                         :        S.of(context)!.addWorkout),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(labelText: S.of(context)!.title),   // ← !
            ),
            TextField(
              controller: _descCtrl,
              decoration: InputDecoration(labelText: S.of(context)!.description), // ← !
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),           // ← !
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (edit && _editIndex != null) {
                  _workouts[_editIndex!] = _Workout(
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                  );
                } else {
                  _workouts.add(_Workout(
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: Text(edit ? S.of(context)!.update     // ← !
                             : S.of(context)!.add),       // ← !
          ),
        ],
      ),
    );
  }

  void _delete(int i) => setState(() => _workouts.removeAt(i));

  void _details(_Workout w) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(w.title),
          content: Text(w.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context)!.close),          // ← !
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final workouts = _workouts;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.workouts),             // ← !
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showDialog)],
      ),
      body: OrientationBuilder(
        builder: (_, __) {
          if (workouts.isEmpty) {
            return Center(child: Text(S.of(context)!.noWorkouts));          // ← !
          }

          if (width < 600) {
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (_, i) => _WorkoutTile(
                workout: workouts[i],
                onTap: () => _details(workouts[i]),
                onLong: () => _delete(i),
                onEdit: () {
                  _editIndex = i;
                  _showDialog(edit: true);
                },
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: workouts.length,
              itemBuilder: (_, i) => _WorkoutCard(
                workout: workouts[i],
                onTap: () => _details(workouts[i]),
                onLong: () => _delete(i),
                onEdit: () {
                  _editIndex = i;
                  _showDialog(edit: true);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

/* ---------- helpers for list vs grid ---------- */

class _WorkoutTile extends StatelessWidget {
  const _WorkoutTile(
      {required this.workout, required this.onTap, required this.onLong, required this.onEdit});
  final _Workout workout;
  final VoidCallback onTap, onLong, onEdit;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(workout.title),
          subtitle: Text(workout.description),
          onTap: onTap,
          onLongPress: onLong,
          trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
        ),
      );
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard(
      {required this.workout, required this.onTap, required this.onLong, required this.onEdit});
  final _Workout workout;
  final VoidCallback onTap, onLong, onEdit;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLong,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(workout.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(workout.description),
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              ],
            ),
          ),
        ),
      );
}
