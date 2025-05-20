import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import 'services/auth_service.dart';

// State & UI
import 'settings_model.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'workouts_page.dart';
import 'progress_page.dart';
import 'profile_page.dart';
import 'l10n/s.dart';
import 'screens/login_page.dart';

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
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('appBox');

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
        StreamProvider<ConnectivityResult>(
          create: (_) => Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none,
        ),
      ],
      child: const WorkoutOrganiserApp(),
    ),
  );
}

class WorkoutOrganiserApp extends StatefulWidget {
  const WorkoutOrganiserApp({super.key});

  @override
  State<WorkoutOrganiserApp> createState() => _WorkoutOrganiserAppState();
}

class _WorkoutOrganiserAppState extends State<WorkoutOrganiserApp> {
  bool _restored = false;
  bool _syncing = false;

  Future<void> _syncData(BuildContext context) async {
    if (!mounted) return;
    
    final authService = context.read<AuthService>();
    final settings = context.read<SettingsModel>();
    
    setState(() => _syncing = true);
    try {
      if (authService.currentUser != null) {
        settings.restoreFromCloud();
        await authService.syncLocalDataToFirebase();
      }
    } finally {
      if (mounted) {
        setState(() => _syncing = false);
      }
    }
  }

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
    final connectivity = context.watch<ConnectivityResult>();
    final isOnline = connectivity != ConnectivityResult.none;

    // Auto-sync when coming back online
    if (isOnline && user != null && !_syncing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _syncData(context);
        }
      });
    }

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
  bool _syncing = false;

  Future<void> _manualSync(BuildContext context) async {
    if (!mounted) return;
    
    setState(() => _syncing = true);
    try {
      final authService = context.read<AuthService>();
      final settings = context.read<SettingsModel>();
      
      if (authService.currentUser != null) {
        settings.restoreFromCloud();
        await authService.syncLocalDataToFirebase();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync completed')), // Temporary solution
        );
      }
    } finally {
      if (mounted) {
        setState(() => _syncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final isOnline = context.watch<ConnectivityResult>() != ConnectivityResult.none;

    final pages = [
      WorkoutsPage(isOnline: isOnline),
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
        actions: [
          if (!isOnline)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_off, color: Colors.red),
            ),
          IconButton(
            icon: _syncing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.sync),
            onPressed: isOnline && !_syncing ? () => _manualSync(context) : null,
            tooltip: isOnline ? 'Sync data' : 'Offline mode', // Temporary solution
          ),
        ],
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