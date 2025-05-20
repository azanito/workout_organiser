import 'package:flutter/material.dart';
import 'login_page.dart';


class GuestGate extends StatelessWidget {
  const GuestGate({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Workout Organiser – Guest')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are in Guest mode. Sign in to unlock the full app 🎉'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                c,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
              child: const Text('Sign in / Register'),
            ),
          ],
        ),
      );
}
