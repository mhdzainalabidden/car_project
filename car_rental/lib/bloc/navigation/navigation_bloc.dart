import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(SplashState()) {
    on<NavigateToOnboarding>(_onNavigateToOnboarding);
    on<NavigateToSignUp>(_onNavigateToSignUp);
    on<NavigateToLogin>(_onNavigateToLogin);
    on<NavigateToSplash>(_onNavigateToSplash);
  }

  void _onNavigateToOnboarding(
    NavigateToOnboarding event,
    Emitter<NavigationState> emit,
  ) {
    emit(OnboardingState());
  }

  void _onNavigateToSignUp(
    NavigateToSignUp event,
    Emitter<NavigationState> emit,
  ) {
    emit(SignUpState());
  }

  void _onNavigateToLogin(
    NavigateToLogin event,
    Emitter<NavigationState> emit,
  ) {
    emit(LoginState());
  }

  void _onNavigateToSplash(
    NavigateToSplash event,
    Emitter<NavigationState> emit,
  ) {
    emit(SplashState());
  }
}
