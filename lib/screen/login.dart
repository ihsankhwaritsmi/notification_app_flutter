import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = "";

  void navigateRegister() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'register');
  }

  void signIn() async {
    setState(() {
      _isLoading = true;
      _errorCode = "";
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!context.mounted) return;
      debugPrint('Login successful, creating notification');
      NotificationService.createNotification(
        id: 8,
        title: 'Login Successful',
        body: 'Login successfully for email ${_emailController.text}',
      );
      // final navigator = Navigator.of(context);
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   if (!context.mounted) return;
      //   Navigator.of(context).pushReplacementNamed('notification');
      // });
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('notification');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
      if (e.code == 'wrong-password') {
        debugPrint('Wrong password, creating notification');
        NotificationService.createNotification(
          id: 9,
          title: 'Login Failed',
          body: 'Wrong password',
        );
      } else if (e.code == 'user-not-found') {
        debugPrint('User not found, creating notification');
        NotificationService.createNotification(
          id: 10,
          title: 'Login Failed',
          body: 'Email hasn\'t registered, please register before login',
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 48),
              Icon(Icons.lock_outline, size: 100, color: Colors.blue[200]),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              const SizedBox(height: 24),
              _errorCode != ""
                  ? Column(
                    children: [Text(_errorCode), const SizedBox(height: 24)],
                  )
                  : const SizedBox(height: 0),
              OutlinedButton(
                onPressed: signIn,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: navigateRegister,
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
