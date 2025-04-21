import 'package:flutter/material.dart';
import 'l10n/s.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)?.aboutTitle ?? 'About Workout Organiser'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏋️ ${S.of(context)?.description ?? 'App Description'}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  S.of(context)?.aboutDescription ??
                      'Workout Organiser is a mobile app designed to help users stay consistent with their fitness goals. '
                      'It allows users to create custom workout plans, track progress, set daily or weekly goals, and get reminders.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('👨‍💻 ${S.of(context)?.credits ?? 'Credits'}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  S.of(context)?.aboutCredits ??
                      'Developed by Orunbek Azan, Zhetkizgen Nurgissa, Aibolat Urzhin in the scope of the course '
                      '“Crossplatform Development” at Astana IT University.\n\n'
                      'Mentor: Assistant Professor Abzal Kyzyrkanov',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('📱 ${S.of(context)?.version ?? 'Version'}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:
                    Text(S.of(context)?.versionNumber ?? 'Version 1.6 – Updated for Assignment 6'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
