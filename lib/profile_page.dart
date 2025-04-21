import 'package:flutter/material.dart';
import 'l10n/s.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)?.profile ?? 'Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context)?.yourProfile ?? 'Your Profile',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Text(S.of(context)?.about ?? 'About Us'),
            ),
            ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  child: Text(S.of(context)!.settings),
                ),
          ],
        ),
      ),
    );
  }
}
