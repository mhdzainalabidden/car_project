import 'package:equatable/equatable.dart';
import 'user.dart';

class Tokens extends Equatable {
  final String access;
  final String refresh;

  const Tokens({required this.access, required this.refresh});

  @override
  List<Object?> get props => [access, refresh];

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(access: json['access'], refresh: json['refresh']);
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'refresh': refresh};
  }
}

class AuthResult extends Equatable {
  final bool isSuccess;
  final User? user;
  final String? message;
  final Tokens? tokens;
  final String? error;

  const AuthResult({
    required this.isSuccess,
    this.user,
    this.message,
    this.tokens,
    this.error,
  });

  @override
  List<Object?> get props => [isSuccess, user, message, tokens, error];

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      isSuccess: true,
      user: User.fromJson(json['user']),
      message: json['message'],
      tokens: Tokens.fromJson(json['tokens']),
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult(isSuccess: false, error: error);
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'user': user?.toJson(),
      'message': message,
      'tokens': tokens?.toJson(),
      'error': error,
    };
  }
}
