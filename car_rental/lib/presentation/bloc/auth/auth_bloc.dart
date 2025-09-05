import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
  }) : _signUpUseCase = signUpUseCase,
       _loginUseCase = loginUseCase,
       _authRepository = authRepository,
       super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      country: event.country,
    );

    if (result.isSuccess && result.user != null) {
      emit(AuthSuccess(user: result.user!));
    } else {
      emit(AuthFailure(error: result.error ?? 'Sign up failed'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUseCase(
      emailOrPhone: event.emailOrPhone,
      password: event.password,
    );

    if (result.isSuccess && result.user != null) {
      emit(AuthSuccess(user: result.user!));
    } else {
      emit(AuthFailure(error: result.error ?? 'Login failed'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthLoggedOut());
  }

  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user: user));
    } else {
      emit(AuthLoggedOut());
    }
  }
}
