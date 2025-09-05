import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResult extends Equatable {
  final User? user;
  final String? token;
  final String? error;
  final bool isSuccess;

  const AuthResult({
    this.user,
    this.token,
    this.error,
    required this.isSuccess,
  });

  const AuthResult.success({required User user, String? token})
    : user = user,
      token = token,
      error = null,
      isSuccess = true;

  const AuthResult.failure({required String error})
    : user = null,
      token = null,
      error = error,
      isSuccess = false;

  @override
  List<Object?> get props => [user, token, error, isSuccess];
}
