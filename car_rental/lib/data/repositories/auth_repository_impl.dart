import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/forgot_password_result.dart';
import '../../domain/entities/phone_verification_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required int countryId,
  }) async {
    final result = await _remoteDataSource.signUp(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      countryId: countryId,
    );

    if (result.isSuccess && result.user != null) {
      await _localDataSource.saveUser(result.user!);
      if (result.tokens != null) {
        await _localDataSource.saveToken(result.tokens!.access);
      }
    }

    return result;
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    if (result.isSuccess && result.user != null) {
      await _localDataSource.saveUser(result.user!);
      if (result.tokens != null) {
        await _localDataSource.saveToken(result.tokens!.access);
      }
    }

    return result;
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearCache();
  }

  @override
  Future<User?> getCurrentUser() async {
    // First try to get from local cache
    final cachedUser = await _localDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser;
    }

    // If not in cache, try to get from remote
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<ForgotPasswordResult> forgotPassword({required String email}) async {
    return await _remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<ResetPasswordResult> resetPassword({
    required String resetToken,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    return await _remoteDataSource.resetPassword(
      resetToken: resetToken,
      code: code,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    final token = await _localDataSource.getCachedToken();
    return user != null && token != null;
  }

  @override
  Future<PhoneVerificationRequestResult> requestPhoneVerification({
    required String phone,
  }) async {
    return await _remoteDataSource.requestPhoneVerification(phone: phone);
  }

  @override
  Future<PhoneVerificationConfirmResult> confirmPhoneVerification({
    required String code,
    required String verifyToken,
  }) async {
    final result = await _remoteDataSource.confirmPhoneVerification(
      code: code,
      verifyToken: verifyToken,
    );

    if (result.isSuccess && result.user != null) {
      await _localDataSource.saveUser(result.user!);
    }

    return result;
  }
}
