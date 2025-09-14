import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<AuthResult> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required int countryId,
  }) async {
    // Validate input
    if (fullName.isEmpty) {
      return AuthResult.failure('Full name is required');
    }
    if (email.isEmpty || !email.contains('@')) {
      return AuthResult.failure('Valid email is required');
    }
    if (phone.isEmpty) {
      return AuthResult.failure('Phone number is required');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters');
    }
    if (countryId <= 0) {
      return AuthResult.failure('Valid country is required');
    }

    return await _authRepository.signUp(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      countryId: countryId,
    );
  }
}
