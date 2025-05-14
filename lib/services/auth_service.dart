import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream used by StreamProvider in main.dart
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register(String email, String pw) =>
      _auth.createUserWithEmailAndPassword(email: email, password: pw);

  Future<UserCredential> login(String email, String pw) =>
      _auth.signInWithEmailAndPassword(email: email, password: pw);

  Future<void> logout() => _auth.signOut();
}
