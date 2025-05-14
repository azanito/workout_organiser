import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mail = TextEditingController(), _pw = TextEditingController();
  bool _loading = false, _isLogin = true;
  final _auth = AuthService();

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await _auth.login(_mail.text.trim(), _pw.text.trim());
      } else {
        await _auth.register(_mail.text.trim(), _pw.text.trim());
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Auth error')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _mail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _pw,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Need an account?' : 'Have an account? Log in'),
              ),
            ],
          ),
        ),
      );
}
