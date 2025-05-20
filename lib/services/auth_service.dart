import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<User?> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showError(context, 'Email and password cannot be empty');
      return null;
    }
    _setLoading(true);
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
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
      _setLoading(false);
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

  // Вот правильный геттер для Stream<User?>, который нужно использовать в StreamProvider
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
