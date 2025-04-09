import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});  // Используем 'const' для неизменяемых классов

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text(
          'About Workout Organiser',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('🏋️ App Description'),
            const SizedBox(height: 10),
            _descriptionCard(
              'Workout Organiser is a mobile app designed to help users stay consistent with their fitness goals. '
              'It allows users to create custom workout plans, track progress, set daily or weekly goals, and get reminders.',
            ),
            const SizedBox(height: 30),
            _sectionTitle('👨‍💻 Credits'),
            const SizedBox(height: 10),
            _descriptionCard(
              'Developed by Orunbek Azan, Zhetkizgen Nurgissa, Aibolat Urzhin in the scope of the course '
              '“Crossplatform Development” at Astana IT University.\n\n'
              'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
            ),
            const SizedBox(height: 30),
            _sectionTitle('📱 Version'),
            const SizedBox(height: 10),
            _descriptionCard('Version 1.0.0 – Initial About Page'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _descriptionCard(String content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
