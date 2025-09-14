import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class SplashState extends NavigationState {}

class OnboardingState extends NavigationState {}

class SignUpState extends NavigationState {}

class LoginState extends NavigationState {}

class ForgotPasswordState extends NavigationState {}

class PhoneVerificationState extends NavigationState {
  final String phone;
  final String verifyToken;

  const PhoneVerificationState({
    required this.phone,
    required this.verifyToken,
  });

  @override
  List<Object> get props => [phone, verifyToken];
}

class HomeState extends NavigationState {}
