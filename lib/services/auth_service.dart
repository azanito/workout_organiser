import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Box? _box;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Online/offline status
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // Инициализация Hive
  Future<void> init() async {
    if (!Hive.isBoxOpen('appBox')) {
      _box = await Hive.openBox('appBox');
    } else {
      _box = Hive.box('appBox');
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // Логин пользователя
  Future<User?> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showError(context, 'Email and password cannot be empty');
      return null;
    }

    _setLoading(true);
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await init();
      await _box?.put('user_uid', result.user?.uid);
      _setLoading(false);
      notifyListeners();
      return result.user;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _showError(context, e.message ?? 'Login failed');
      return null;
    } catch (e) {
      _setLoading(false);
      _showError(context, 'Unexpected error: $e');
      return null;
    }
  }

  // Регистрация пользователя
  Future<User?> register(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showError(context, 'Email and password cannot be empty');
      return null;
    }
    if (password.length < 6) {
      _showError(context, 'Password should be at least 6 characters');
      return null;
    }

    _setLoading(true);
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await init();
      await _box?.put('user_uid', result.user?.uid);
      _setLoading(false);
      notifyListeners();
      return result.user;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _showError(context, e.message ?? 'Registration failed');
      return null;
    } catch (e) {
      _setLoading(false);
      _showError(context, 'Unexpected error: $e');
      return null;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Проверка, залогинен ли пользователь (постоянный вход)
  Future<bool> isUserLoggedIn() async {
    await init();
    final user = _auth.currentUser;
    if (user != null) {
      await _box?.put('user_uid', user.uid);
      return true;
    }
    final savedUid = _box?.get('user_uid');
    return savedUid != null;
  }

  // Выход из аккаунта
  Future<void> logout() async {
    await _auth.signOut();
    await init();
    await _box?.delete('user_uid');
    notifyListeners();
  }

  // Синхронизация локальных данных с Firebase (пример, адаптируй под структуру своих данных)
  Future<void> syncLocalDataToFirebase() async {
    if (!_isOnline) return;

    await init();
    _setLoading(true);
    try {
      final localData = _box?.get('local_data');
      if (localData != null && currentUser != null) {
        // TODO: Реализовать отправку localData в Firebase (Firestore или Realtime Database)
        // Пример:
        // await FirebaseFirestore.instance
        //   .collection('userData')
        //   .doc(currentUser!.uid)
        //   .set(localData);

        // После успешной синхронизации удаляем локальные данные
        await _box?.delete('local_data');
      }
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Сохраняем данные локально
  Future<void> saveLocalData(dynamic data) async {
    await init();
    await _box?.put('local_data', data);
  }

  // Обновление статуса онлайн/офлайн и запуск синхронизации при переходе онлайн
  Future<void> updateOnlineStatus(bool status) async {
    _isOnline = status;
    notifyListeners();
    if (_isOnline && currentUser != null) {
      await syncLocalDataToFirebase();
    }
  }

  // Проверка активной сессии (сохраняем постоянный вход)
  Future<bool> checkCurrentSession() async {
    return await isUserLoggedIn();
  }
}
