import '../entities/phone_verification_result.dart';
import '../repositories/auth_repository.dart';

class ConfirmPhoneVerificationUseCase {
  final AuthRepository _authRepository;

  ConfirmPhoneVerificationUseCase(this._authRepository);

  Future<PhoneVerificationConfirmResult> call({
    required String code,
    required String verifyToken,
  }) async {
    return await _authRepository.confirmPhoneVerification(
      code: code,
      verifyToken: verifyToken,
    );
  }
}
