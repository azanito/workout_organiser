import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// 🌐 Services
import 'services/auth_service.dart';

// 🧠 State & UI
import 'settings_model.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'workouts_page.dart';
import 'progress_page.dart';
import 'profile_page.dart';
import 'l10n/s.dart';
import 'screens/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

/// ---------- LIGHT & DARK THEMES ----------
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
          catchError: (_, __) => null,
        ),
      ],
      child: const WorkoutOrganiserApp(),
    ),
  );
}

/// 🧠 Stateful версия для безопасного использования restoreFromCloud
class WorkoutOrganiserApp extends StatefulWidget {
  const WorkoutOrganiserApp({super.key});

  @override
  State<WorkoutOrganiserApp> createState() => _WorkoutOrganiserAppState();
}

class _WorkoutOrganiserAppState extends State<WorkoutOrganiserApp> {
  bool _restored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_restored) {
      final user = context.read<User?>();
      final settings = context.read<SettingsModel>();
      if (user != null) {
        settings.restoreFromCloud();
      }
      _restored = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
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
      home: user == null ? const LoginPage() : const MainNavigationScreen(),
      routes: {
        '/settings': (_) => const SettingsPage(),
        '/about': (_) => const AboutPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    final pages = [
      const WorkoutsPage(),
      const ProgressPage(),
      if (user != null) const ProfilePage(),
    ];

    final labels = [
      S.of(context)!.workouts,
      S.of(context)!.progress,
      if (user != null) S.of(context)!.profile,
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
      appBar: AppBar(
        title: Text(S.of(context)!.appTitle),
      ),
      body: pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected.clamp(0, pages.length - 1),
        onTap: (i) => setState(() => _selected = i),
        selectedItemColor: Colors.green,
        items: [
          for (final l in labels)
            BottomNavigationBarItem(
              icon: const Icon(Icons.circle),
              label: l,
            ),
        ],
      ),
    );
  }
}

class GuestGate extends StatelessWidget {
  const GuestGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${S.of(context)!.profile} (Guest Mode)'),
      ),
    );
  }
}
