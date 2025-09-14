import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(SplashState()) {
    on<NavigateToOnboarding>(_onNavigateToOnboarding);
    on<NavigateToSignUp>(_onNavigateToSignUp);
    on<NavigateToLogin>(_onNavigateToLogin);
    on<NavigateToSplash>(_onNavigateToSplash);
    on<NavigateToForgotPassword>(_onNavigateToForgotPassword);
    on<NavigateToPhoneVerification>(_onNavigateToPhoneVerification);
    on<NavigateToHome>(_onNavigateToHome);
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

  void _onNavigateToForgotPassword(
    NavigateToForgotPassword event,
    Emitter<NavigationState> emit,
  ) {
    emit(ForgotPasswordState());
  }

  void _onNavigateToPhoneVerification(
    NavigateToPhoneVerification event,
    Emitter<NavigationState> emit,
  ) {
    emit(
      PhoneVerificationState(
        phone: event.phone,
        verifyToken: event.verifyToken,
      ),
    );
  }

  void _onNavigateToHome(NavigateToHome event, Emitter<NavigationState> emit) {
    emit(HomeState());
  }
}
