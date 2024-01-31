import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class registerForm extends StatefulWidget {
  const registerForm({Key? key}) : super(key: key);

  @override
  _registerForm createState() => _registerForm();
}

class _registerForm extends State<registerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _submitForm() async {
    var url = Uri.parse('http://localhost:4000/users');

    var data = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'email': _emailController.text
    };

    try {
      final response = await http.post(url, body: data);
      if (response.statusCode == 201) {
        print('Éxito');
        _formKey.currentState?.reset();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud POST: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTRO DE USUARIO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Usuario:'),
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Contraseña:'),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Email:'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
