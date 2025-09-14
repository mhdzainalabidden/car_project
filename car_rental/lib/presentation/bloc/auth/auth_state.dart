import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/forgot_password_result.dart';
import '../../../domain/entities/phone_verification_result.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthLoggedOut extends AuthState {}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final ForgotPasswordResult result;

  const ForgotPasswordSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class ForgotPasswordFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errors;

  const ForgotPasswordFailure({required this.error, this.errors});

  @override
  List<Object?> get props => [error, errors];
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final ResetPasswordResult result;

  const ResetPasswordSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class ResetPasswordFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errors;

  const ResetPasswordFailure({required this.error, this.errors});

  @override
  List<Object?> get props => [error, errors];
}

class PhoneVerificationRequestLoading extends AuthState {}

class PhoneVerificationRequestSuccess extends AuthState {
  final PhoneVerificationRequestResult result;

  const PhoneVerificationRequestSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class PhoneVerificationRequestFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errors;

  const PhoneVerificationRequestFailure({required this.error, this.errors});

  @override
  List<Object?> get props => [error, errors];
}

class PhoneVerificationConfirmLoading extends AuthState {}

class PhoneVerificationConfirmSuccess extends AuthState {
  final PhoneVerificationConfirmResult result;

  const PhoneVerificationConfirmSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class PhoneVerificationConfirmFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errors;

  const PhoneVerificationConfirmFailure({required this.error, this.errors});

  @override
  List<Object?> get props => [error, errors];
}
