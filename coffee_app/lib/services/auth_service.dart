import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:coffee_app/models/user.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.93:4000/api';
  static final _storage = const FlutterSecureStorage();

  static Future<User> register(
    String username,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      final user = User.fromJson(data['user']);
      await _storage.write(key: 'auth_token', value: data['token']);
      await _storage.write(key: 'user_id', value: user.id.toString());
      await _storage.write(key: 'username', value: user.username);
      await _storage.write(key: 'email', value: user.email);
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid Registration');
    } else {
      throw Exception('Register failed');
    }
  }

  static Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      final user = User.fromJson(data['user']);
      await _storage.write(key: 'auth_token', value: data['token']);
      await _storage.write(key: 'user_id', value: user.id.toString());
      await _storage.write(key: 'username', value: user.username);
      await _storage.write(key: 'email', value: user.email);
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid Credentials');
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'email');
  }

  static Future<bool> isLoggedIn() async {
    if (await _storage.read(key: 'auth_token') != null) {
      return true;
    }
    return false;
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<int?> getCurrentUserId() async {
    final value = await _storage.read(key: 'user_id');
    if (value == null) return null;
    return int.tryParse(value);
  }

  static Future<String?> getCurrentUsername() async {
    return await _storage.read(key: 'username');
  }

  static Future<String?> getCurrentEmail() async {
    return await _storage.read(key: 'email');
  }

  static Future<User?> getCurrentUser() async {
    final id = await getCurrentUserId();
    if (id == null) {
      return null;
    }
    final username = await getCurrentUsername();
    if (username == null) {
      return null;
    }
    final email = await getCurrentEmail();
    if (email == null) {
      return null;
    }
    return User(id: id, username: username, email: email);
  }
}
