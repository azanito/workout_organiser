import 'package:flutter/material.dart';
import 'l10n/s.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)?.progress ?? 'Progress Tracker'),
      ),
      body: Center(
        child: Text(
          S.of(context)?.trackProgress ??
              'Track your workout progress here!',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
