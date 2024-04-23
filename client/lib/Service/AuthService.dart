import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'AuthData.dart';

class AuthService {
  Future<AuthData?> login(String username, String password) async {
    final url = Uri.parse('http://localhost:4000/auth/login');
    final response = await http.post(
      url,
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token = responseData['accessToken'] as String;
      final userId = responseData['userId'] as int;
      window.sessionStorage['accessToken'] = token;
      window.sessionStorage['userId'] = userId.toString();
      return AuthData(accessToken: token, userId: userId);
    } else {
      throw Exception('Failed to login');
    }
  }

  String getUserId() {
    // Obtener el userId del sessionStorage
    final userId = window.sessionStorage['userId'];
    if (userId != null) {
      return userId;
    } else {
      throw Exception('User not logged in');
    }
  }
}
