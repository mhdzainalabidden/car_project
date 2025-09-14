import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Domain
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/countries_repository.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/request_phone_verification_usecase.dart';
import '../domain/usecases/confirm_phone_verification_usecase.dart';
import '../domain/usecases/get_countries_usecase.dart';

// Data
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_local_datasource_impl.dart';
import '../data/datasources/countries_remote_datasource.dart';
import '../data/datasources/countries_remote_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/countries_repository_impl.dart';

// Presentation
import '../presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      baseUrl: 'https://qent.up.railway.app',
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(
      client: sl(),
      baseUrl: 'https://qent.up.railway.app',
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => RequestPhoneVerificationUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPhoneVerificationUseCase(sl()));
  sl.registerLazySingleton(() => GetCountriesUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      requestPhoneVerificationUseCase: sl(),
      confirmPhoneVerificationUseCase: sl(),
      authRepository: sl(),
    ),
  );
}
