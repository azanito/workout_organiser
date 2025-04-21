import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'settings_model.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'workouts_page.dart';
import 'progress_page.dart';
import 'profile_page.dart';
import 'l10n/s.dart';

/// ----------  LIGHT & DARK THEMES ----------
final ThemeData kLightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primarySwatch: Colors.green,
  scaffoldBackgroundColor: Colors.white,
);

final ThemeData kDarkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: const WorkoutOrganiserApp(),
    ),
  );
}

class WorkoutOrganiserApp extends StatelessWidget {
  const WorkoutOrganiserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();

    return MaterialApp(
      title: 'Workout Organiser',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      initialRoute: '/',
      routes: {
        '/':         (_) => const MainNavigationScreen(),
        '/settings': (_) => const SettingsPage(),
        '/about':    (_) => const AboutPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selected = 0;
  static const _pages = [
    WorkoutsPage(),
    ProgressPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ---------- Drawer ----------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                S.of(context)!.appTitle,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(S.of(context)!.settings),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(S.of(context)!.about),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),

      /// ---------- AppBar (показывает бургер) ----------
      appBar: AppBar(
        title: Text(S.of(context)!.appTitle),
      ),

      /// ---------- Main body ----------
      body: _pages[_selected],

      /// ---------- BottomNavigation ----------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: S.of(context)!.workouts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.show_chart),
            label: S.of(context)!.progress,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: S.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
