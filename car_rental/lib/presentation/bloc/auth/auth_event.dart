import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String country;

  const SignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.country,
  });

  @override
  List<Object?> get props => [fullName, email, password, country];
}

class LoginRequested extends AuthEvent {
  final String emailOrPhone;
  final String password;

  const LoginRequested({required this.emailOrPhone, required this.password});

  @override
  List<Object?> get props => [emailOrPhone, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}
