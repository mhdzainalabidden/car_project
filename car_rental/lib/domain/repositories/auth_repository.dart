import '../entities/auth_result.dart';
import '../entities/user.dart';
import '../entities/forgot_password_result.dart';
import '../entities/phone_verification_result.dart';

abstract class AuthRepository {
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
  Future<bool> isLoggedIn();

  Future<PhoneVerificationRequestResult> requestPhoneVerification({
    required String phone,
  });

  Future<PhoneVerificationConfirmResult> confirmPhoneVerification({
    required String code,
    required String verifyToken,
  });
}
