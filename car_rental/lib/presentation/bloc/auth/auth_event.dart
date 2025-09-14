import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final int countryId;

  const SignUpRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.countryId,
  });

  @override
  List<Object?> get props => [fullName, email, phone, password, countryId];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String resetToken;
  final String code;
  final String password;
  final String confirmPassword;

  const ResetPasswordRequested({
    required this.resetToken,
    required this.code,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [resetToken, code, password, confirmPassword];
}

class RequestPhoneVerificationRequested extends AuthEvent {
  final String phone;

  const RequestPhoneVerificationRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class ConfirmPhoneVerificationRequested extends AuthEvent {
  final String code;
  final String verifyToken;

  const ConfirmPhoneVerificationRequested({
    required this.code,
    required this.verifyToken,
  });

  @override
  List<Object?> get props => [code, verifyToken];
}
