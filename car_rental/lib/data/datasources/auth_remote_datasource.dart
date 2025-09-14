import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/forgot_password_result.dart';
import '../../domain/entities/phone_verification_result.dart';
import 'auth_local_datasource.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required int countryId,
  });

  Future<AuthResult> login({required String email, required String password});

  Future<ForgotPasswordResult> forgotPassword({required String email});

  Future<ResetPasswordResult> resetPassword({
    required String resetToken,
    required String code,
    required String password,
    required String confirmPassword,
  });

  Future<void> logout();
  Future<User?> getCurrentUser();

  Future<PhoneVerificationRequestResult> requestPhoneVerification({
    required String phone,
  });

  Future<PhoneVerificationConfirmResult> confirmPhoneVerification({
    required String code,
    required String verifyToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.localDataSource,
  });

  @override
  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required int countryId,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'country_id': countryId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AuthResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        return AuthResult.failure(errorData['message'] ?? 'Sign up failed');
      }
    } catch (e) {
      return AuthResult.failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        return AuthResult.failure(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      return AuthResult.failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    // Implement logout logic here
    // This might involve calling a logout endpoint or clearing local storage
  }

  @override
  Future<ForgotPasswordResult> forgotPassword({required String email}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/forgot_password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ForgotPasswordResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('errors')) {
          return ForgotPasswordResult.failureWithErrors(errorData['errors']);
        }
        return ForgotPasswordResult.failure(
          errorData['message'] ?? 'Failed to send reset code',
        );
      }
    } catch (e) {
      return ForgotPasswordResult.failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ResetPasswordResult> resetPassword({
    required String resetToken,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/reset_password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reset_token': resetToken,
          'code': code,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ResetPasswordResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('errors')) {
          return ResetPasswordResult.failureWithErrors(errorData['errors']);
        }
        return ResetPasswordResult.failure(
          errorData['message'] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      return ResetPasswordResult.failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // Implement get current user logic here
    // This might involve checking local storage or calling a profile endpoint
    return null;
  }

  @override
  Future<PhoneVerificationRequestResult> requestPhoneVerification({
    required String phone,
  }) async {
    try {
      print('Requesting phone verification for: $phone');

      // Get the authentication token
      final token = await localDataSource.getCachedToken();
      if (token == null) {
        print('No authentication token found');
        return PhoneVerificationRequestResult.failure(
          'Authentication required. Please login first.',
        );
      }

      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/phone/request_verify_code/'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: 'phone=$phone',
      );

      print('Phone verification response status: ${response.statusCode}');
      print('Phone verification response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PhoneVerificationRequestResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('errors')) {
          return PhoneVerificationRequestResult.failureWithErrors(
            errorData['errors'],
          );
        }
        return PhoneVerificationRequestResult.failure(
          errorData['message'] ?? 'Failed to send verification code',
        );
      }
    } catch (e) {
      print('Phone verification error: $e');
      return PhoneVerificationRequestResult.failure(
        'Network error: ${e.toString()}',
      );
    }
  }

  @override
  Future<PhoneVerificationConfirmResult> confirmPhoneVerification({
    required String code,
    required String verifyToken,
  }) async {
    try {
      print(
        'Confirming phone verification with code: $code, token: $verifyToken',
      );

      // Get the authentication token
      final token = await localDataSource.getCachedToken();
      if (token == null) {
        print('No authentication token found');
        return PhoneVerificationConfirmResult.failure(
          'Authentication required. Please login first.',
        );
      }

      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/phone/confirm_verify_code/'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: 'code=$code&verify_token=$verifyToken',
      );

      print('Phone confirmation response status: ${response.statusCode}');
      print('Phone confirmation response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PhoneVerificationConfirmResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('errors')) {
          return PhoneVerificationConfirmResult.failureWithErrors(
            errorData['errors'],
          );
        }
        return PhoneVerificationConfirmResult.failure(
          errorData['message'] ?? 'Failed to verify phone number',
        );
      }
    } catch (e) {
      print('Phone confirmation error: $e');
      return PhoneVerificationConfirmResult.failure(
        'Network error: ${e.toString()}',
      );
    }
  }
}
