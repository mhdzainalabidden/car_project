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
