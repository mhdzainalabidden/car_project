import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<AuthResult> call({
    required String fullName,
    required String email,
    required String password,
    required String country,
  }) async {
    // Validate input
    if (fullName.isEmpty) {
      return const AuthResult.failure(error: 'Full name is required');
    }
    if (email.isEmpty || !email.contains('@')) {
      return const AuthResult.failure(error: 'Valid email is required');
    }
    if (password.length < 6) {
      return const AuthResult.failure(
        error: 'Password must be at least 6 characters',
      );
    }
    if (country.isEmpty) {
      return const AuthResult.failure(error: 'Country is required');
    }

    return await _authRepository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      country: country,
    );
  }
}
