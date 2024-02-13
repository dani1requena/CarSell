import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';
import 'package:app_car/Service/AuthService.dart';
import 'package:app_car/main.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService authService = AuthService();

  void _submitForm() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      final token = await authService.login(username, password);
      window.sessionStorage['accessToken'] = token!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'HomePage')),
      );
    } catch (e) {
      print('Error de inicio de sesión: $e');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: TabBarView(
            children: [
              LoginCard(
                onPressed: _submitForm,
                usernameController: _usernameController,
                passwordController: _passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  final html.VoidCallback onPressed;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginCard({
    Key? key,
    required this.onPressed,
    required this.usernameController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressed,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
