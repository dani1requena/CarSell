import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('http://localhost:4000/auth/login');
    final response = await http.post(
      url,
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 201) {
      final token = jsonDecode(response.body)['accessToken'];
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }
}
