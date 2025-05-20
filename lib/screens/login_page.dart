import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> _submit(AuthService authService) async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus(); // Скрыть клавиатуру

    try {
      if (_isLogin) {
        await authService.login(
          context,
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await authService.register(
          context,
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication error')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!_isLogin && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  autofillHints: _isLogin
                      ? [AutofillHints.password]
                      : [AutofillHints.newPassword],
                ),
                const SizedBox(height: 24),

                // Кнопка или индикатор загрузки
                authService.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submit(authService),
                          child: Text(_isLogin ? 'Login' : 'Register'),
                        ),
                      ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  },
                  child: Text(_isLogin
                      ? 'Don\'t have an account? Register'
                      : 'Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
