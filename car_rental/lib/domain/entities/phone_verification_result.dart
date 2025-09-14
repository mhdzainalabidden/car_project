import 'package:equatable/equatable.dart';
import 'user.dart';

class PhoneVerificationRequestResult extends Equatable {
  final bool isSuccess;
  final String? message;
  final String? phone;
  final String? verifyToken;
  final String? error;
  final Map<String, dynamic>? errors;

  const PhoneVerificationRequestResult({
    required this.isSuccess,
    this.message,
    this.phone,
    this.verifyToken,
    this.error,
    this.errors,
  });

  @override
  List<Object?> get props => [
    isSuccess,
    message,
    phone,
    verifyToken,
    error,
    errors,
  ];

  factory PhoneVerificationRequestResult.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationRequestResult(
      isSuccess: true,
      message: json['message'],
      phone: json['phone'],
      verifyToken: json['verify_token'],
    );
  }

  factory PhoneVerificationRequestResult.failure(String error) {
    return PhoneVerificationRequestResult(isSuccess: false, error: error);
  }

  factory PhoneVerificationRequestResult.failureWithErrors(
    Map<String, dynamic> errors,
  ) {
    return PhoneVerificationRequestResult(isSuccess: false, errors: errors);
  }
}

class PhoneVerificationConfirmResult extends Equatable {
  final bool isSuccess;
  final String? message;
  final User? user;
  final String? error;
  final Map<String, dynamic>? errors;

  const PhoneVerificationConfirmResult({
    required this.isSuccess,
    this.message,
    this.user,
    this.error,
    this.errors,
  });

  @override
  List<Object?> get props => [isSuccess, message, user, error, errors];

  factory PhoneVerificationConfirmResult.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationConfirmResult(
      isSuccess: true,
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }

  factory PhoneVerificationConfirmResult.failure(String error) {
    return PhoneVerificationConfirmResult(isSuccess: false, error: error);
  }

  factory PhoneVerificationConfirmResult.failureWithErrors(
    Map<String, dynamic> errors,
  ) {
    return PhoneVerificationConfirmResult(isSuccess: false, errors: errors);
  }
}
