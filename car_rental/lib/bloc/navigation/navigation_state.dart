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
