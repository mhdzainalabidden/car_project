import 'package:equatable/equatable.dart';

class ForgotPasswordResult extends Equatable {
  final bool isSuccess;
  final String? message;
  final String? code;
  final String? resetToken;
  final String? error;
  final Map<String, dynamic>? errors;

  const ForgotPasswordResult({
    required this.isSuccess,
    this.message,
    this.code,
    this.resetToken,
    this.error,
    this.errors,
  });

  @override
  List<Object?> get props => [
    isSuccess,
    message,
    code,
    resetToken,
    error,
    errors,
  ];

  factory ForgotPasswordResult.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResult(
      isSuccess: true,
      message: json['message'],
      code: json['code'],
      resetToken: json['reset_token'],
    );
  }

  factory ForgotPasswordResult.failure(String error) {
    return ForgotPasswordResult(isSuccess: false, error: error);
  }

  factory ForgotPasswordResult.failureWithErrors(Map<String, dynamic> errors) {
    return ForgotPasswordResult(isSuccess: false, errors: errors);
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'code': code,
      'reset_token': resetToken,
      'error': error,
      'errors': errors,
    };
  }
}

class ResetPasswordResult extends Equatable {
  final bool isSuccess;
  final String? message;
  final String? error;
  final Map<String, dynamic>? errors;

  const ResetPasswordResult({
    required this.isSuccess,
    this.message,
    this.error,
    this.errors,
  });

  @override
  List<Object?> get props => [isSuccess, message, error, errors];

  factory ResetPasswordResult.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResult(isSuccess: true, message: json['message']);
  }

  factory ResetPasswordResult.failure(String error) {
    return ResetPasswordResult(isSuccess: false, error: error);
  }

  factory ResetPasswordResult.failureWithErrors(Map<String, dynamic> errors) {
    return ResetPasswordResult(isSuccess: false, errors: errors);
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'error': error,
      'errors': errors,
    };
  }
}
