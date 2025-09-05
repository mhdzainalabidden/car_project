import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<AuthResult> call({
    required String emailOrPhone,
    required String password,
  }) async {
    // Validate input
    if (emailOrPhone.isEmpty) {
      return const AuthResult.failure(
        error: 'Email or phone number is required',
      );
    }
    if (password.isEmpty) {
      return const AuthResult.failure(error: 'Password is required');
    }

    return await _authRepository.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );
  }
}
