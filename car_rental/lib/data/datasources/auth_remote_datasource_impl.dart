import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_remote_datasource.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String password,
    required String country,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'country': country,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = User(
          id: data['user']['id'],
          fullName: data['user']['fullName'],
          email: data['user']['email'],
          country: data['user']['country'],
          createdAt: DateTime.parse(data['user']['createdAt']),
        );
        return AuthResult.success(user: user, token: data['token']);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Sign up failed';
        return AuthResult.failure(error: error);
      }
    } catch (e) {
      return AuthResult.failure(error: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailOrPhone': emailOrPhone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User(
          id: data['user']['id'],
          fullName: data['user']['fullName'],
          email: data['user']['email'],
          country: data['user']['country'],
          createdAt: DateTime.parse(data['user']['createdAt']),
        );
        return AuthResult.success(user: user, token: data['token']);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        return AuthResult.failure(error: error);
      }
    } catch (e) {
      return AuthResult.failure(error: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout API call
  }

  @override
  Future<User?> getCurrentUser() async {
    // TODO: Implement get current user API call
    return null;
  }
}
