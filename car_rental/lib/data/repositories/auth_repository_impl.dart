import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
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
    required String password,
    required String country,
  }) async {
    final result = await _remoteDataSource.signUp(
      fullName: fullName,
      email: email,
      password: password,
      country: country,
    );

    if (result.isSuccess && result.user != null) {
      await _localDataSource.saveUser(result.user!);
      if (result.token != null) {
        await _localDataSource.saveToken(result.token!);
      }
    }

    return result;
  }

  @override
  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    if (result.isSuccess && result.user != null) {
      await _localDataSource.saveUser(result.user!);
      if (result.token != null) {
        await _localDataSource.saveToken(result.token!);
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
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    final token = await _localDataSource.getCachedToken();
    return user != null && token != null;
  }
}
