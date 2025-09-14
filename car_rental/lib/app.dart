import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection/injection_container.dart' as di;
import 'bloc/navigation/navigation_bloc.dart';
import 'bloc/navigation/navigation_state.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/phone_verification_request_screen.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Qent Car Rental',
        theme: ThemeData(primarySwatch: Colors.grey, useMaterial3: true),
        home: const AppNavigator(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return switch (state) {
          SplashState() => const SplashScreen(),
          OnboardingState() => const OnboardingScreen(),
          SignUpState() => const SignUpScreen(),
          LoginState() => const LoginScreen(),
          ForgotPasswordState() => const ForgotPasswordScreen(),
          PhoneVerificationState(phone: final phone, verifyToken: _) =>
            PhoneVerificationRequestScreen(
              initialPhone: phone,
              initialCountryCode: '+1', // Default country code
            ),
          HomeState() => const HomeScreen(),
          _ => const SplashScreen(),
        };
      },
    );
  }
}
