import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/forgot_password_usecase.dart';
import '../../../domain/usecases/request_phone_verification_usecase.dart';
import '../../../domain/usecases/confirm_phone_verification_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final RequestPhoneVerificationUseCase _requestPhoneVerificationUseCase;
  final ConfirmPhoneVerificationUseCase _confirmPhoneVerificationUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LoginUseCase loginUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required RequestPhoneVerificationUseCase requestPhoneVerificationUseCase,
    required ConfirmPhoneVerificationUseCase confirmPhoneVerificationUseCase,
    required AuthRepository authRepository,
  }) : _signUpUseCase = signUpUseCase,
       _loginUseCase = loginUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _requestPhoneVerificationUseCase = requestPhoneVerificationUseCase,
       _confirmPhoneVerificationUseCase = confirmPhoneVerificationUseCase,
       _authRepository = authRepository,
       super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<RequestPhoneVerificationRequested>(_onRequestPhoneVerificationRequested);
    on<ConfirmPhoneVerificationRequested>(_onConfirmPhoneVerificationRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(
      fullName: event.fullName,
      email: event.email,
      phone: event.phone,
      password: event.password,
      countryId: event.countryId,
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
      email: event.email,
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

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    final result = await _forgotPasswordUseCase(email: event.email);

    if (result.isSuccess) {
      emit(ForgotPasswordSuccess(result: result));
    } else {
      emit(
        ForgotPasswordFailure(
          error: result.error ?? 'Failed to send reset code',
          errors: result.errors,
        ),
      );
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResetPasswordLoading());

    final result = await _resetPasswordUseCase(
      resetToken: event.resetToken,
      code: event.code,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    if (result.isSuccess) {
      emit(ResetPasswordSuccess(result: result));
    } else {
      emit(
        ResetPasswordFailure(
          error: result.error ?? 'Failed to reset password',
          errors: result.errors,
        ),
      );
    }
  }

  Future<void> _onRequestPhoneVerificationRequested(
    RequestPhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('AuthBloc: Requesting phone verification for: ${event.phone}');
    emit(PhoneVerificationRequestLoading());

    final result = await _requestPhoneVerificationUseCase(phone: event.phone);
    print('AuthBloc: Phone verification result: $result');

    if (result.isSuccess) {
      print('AuthBloc: Phone verification success, emitting success state');
      emit(PhoneVerificationRequestSuccess(result: result));
    } else {
      print('AuthBloc: Phone verification failed: ${result.error}');
      emit(
        PhoneVerificationRequestFailure(
          error: result.error ?? 'Failed to send verification code',
          errors: result.errors,
        ),
      );
    }
  }

  Future<void> _onConfirmPhoneVerificationRequested(
    ConfirmPhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('AuthBloc: Confirming phone verification with code: ${event.code}');
    emit(PhoneVerificationConfirmLoading());

    final result = await _confirmPhoneVerificationUseCase(
      code: event.code,
      verifyToken: event.verifyToken,
    );
    print('AuthBloc: Phone confirmation result: $result');

    if (result.isSuccess) {
      print('AuthBloc: Phone confirmation success, emitting success state');
      emit(PhoneVerificationConfirmSuccess(result: result));
    } else {
      print('AuthBloc: Phone confirmation failed: ${result.error}');
      emit(
        PhoneVerificationConfirmFailure(
          error: result.error ?? 'Failed to verify phone number',
          errors: result.errors,
        ),
      );
    }
  }
}
