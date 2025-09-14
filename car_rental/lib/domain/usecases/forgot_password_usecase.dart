import '../entities/forgot_password_result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<ForgotPasswordResult> call({required String email}) async {
    return await _repository.forgotPassword(email: email);
  }
}

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<ResetPasswordResult> call({
    required String resetToken,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    return await _repository.resetPassword(
      resetToken: resetToken,
      code: code,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
