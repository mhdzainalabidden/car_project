import '../entities/auth_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String password,
    required String country,
  });

  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  });

  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}
