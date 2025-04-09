import 'package:flutter/material.dart';
import 'home_screen.dart';  // Импортируем HomeScreen
import 'about_page.dart';   // Импортируем AboutPage

void main() {
  runApp(WorkoutOrganiserApp());
}

class WorkoutOrganiserApp extends StatelessWidget {
  WorkoutOrganiserApp({super.key});  // Убираем 'const' из конструктора

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Organiser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),  // Устанавливаем SplashScreen как начальную страницу
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Organiser"),
        backgroundColor: Colors.green.shade600,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Workout Organizer!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Переход на HomeScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text("Go to Home"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Переход на AboutPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()), // Используем AboutPage
                );
              },
              child: const Text("About Us"),
            ),
          ],
        ),
      ),
    );
  }
}
