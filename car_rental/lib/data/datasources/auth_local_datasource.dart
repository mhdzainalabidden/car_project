import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<void> saveToken(String token);
  Future<User?> getCachedUser();
  Future<String?> getCachedToken();
  Future<void> clearCache();
}
