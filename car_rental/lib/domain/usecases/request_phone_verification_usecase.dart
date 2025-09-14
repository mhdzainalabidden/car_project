import '../entities/phone_verification_result.dart';
import '../repositories/auth_repository.dart';

class RequestPhoneVerificationUseCase {
  final AuthRepository _authRepository;

  RequestPhoneVerificationUseCase(this._authRepository);

  Future<PhoneVerificationRequestResult> call({required String phone}) async {
    return await _authRepository.requestPhoneVerification(phone: phone);
  }
}
