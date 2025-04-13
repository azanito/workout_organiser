import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Tracker"),
        backgroundColor: Colors.green.shade600,
      ),
      body: Center(
        child: Text(
          "Track your workout progress here!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
