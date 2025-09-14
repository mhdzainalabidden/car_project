import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToOnboarding extends NavigationEvent {}

class NavigateToSignUp extends NavigationEvent {}

class NavigateToLogin extends NavigationEvent {}

class NavigateToSplash extends NavigationEvent {}

class NavigateToForgotPassword extends NavigationEvent {}

class NavigateToPhoneVerification extends NavigationEvent {
  final String phone;
  final String verifyToken;

  const NavigateToPhoneVerification({
    required this.phone,
    required this.verifyToken,
  });

  @override
  List<Object> get props => [phone, verifyToken];
}

class NavigateToHome extends NavigationEvent {}
