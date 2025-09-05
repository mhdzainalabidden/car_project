import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
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
}
