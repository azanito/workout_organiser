import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Используем тему по умолчанию для поддержки темной/светлой темы
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
            _sectionTitle('🏋️ App Description', context),
            const SizedBox(height: 10),
            _descriptionCard(
              context,
              'Workout Organiser is a mobile app designed to help users stay consistent with their fitness goals. '
              'It allows users to create custom workout plans, track progress, set daily or weekly goals, and get reminders.',
            ),
            const SizedBox(height: 30),
            _sectionTitle('👨‍💻 Credits', context),
            const SizedBox(height: 10),
            _descriptionCard(
              context,
              'Developed by Orunbek Azan, Zhetkizgen Nurgissa, Aibolat Urzhin in the scope of the course '
              '“Crossplatform Development” at Astana IT University.\n\n'
              'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
            ),
            const SizedBox(height: 30),
            _sectionTitle('📱 Version', context),
            const SizedBox(height: 10),
            _descriptionCard(context, 'Version 1.4 – Updated for Assignment 4'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _descriptionCard(BuildContext context, String content) {
    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ),
    );
  }
}
