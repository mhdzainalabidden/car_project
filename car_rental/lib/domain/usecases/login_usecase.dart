import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    // Validate input
    if (email.isEmpty) {
      return AuthResult.failure('Email is required');
    }
    if (password.isEmpty) {
      return AuthResult.failure('Password is required');
    }

    return await _authRepository.login(email: email, password: password);
  }
}
