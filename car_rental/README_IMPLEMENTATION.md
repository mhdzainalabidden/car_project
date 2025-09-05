# Car Rental App - Four Screen Implementation

This Flutter app implements four screens using BLoC state management as requested:

## Screens Implemented

### 1. Splash Screen
- **File**: `lib/screens/splash_screen.dart`
- **Background**: Uses `assets/images/Baground.png`
- **Features**: 
  - Logo with car icon
  - "Welcome to Qent" text
  - Auto-navigation to onboarding after 3 seconds
  - Dark overlay on background image

### 2. Onboarding Screen
- **File**: `lib/screens/onboarding_screen.dart`
- **Background**: Uses `assets/images/car.png`
- **Features**:
  - PageView with 2 onboarding pages
  - Page indicators (dots)
  - "Get Started" button to navigate to sign-up
  - Dark overlay on background image

### 3. Sign Up Screen
- **File**: `lib/screens/signup_screen.dart`
- **Features**:
  - Form with validation for:
    - Full Name
    - Email Address
    - Password (with visibility toggle)
    - Country
  - "Sign up" and "Login" buttons
  - Apple Pay and Google Pay buttons (placeholder)
  - Form validation with error messages

### 4. Login Screen
- **File**: `lib/screens/login_screen.dart`
- **Features**:
  - Email/Phone and Password fields
  - "Remember Me" checkbox
  - "Forgot Password" link
  - "Login" and "Sign up" buttons
  - Apple Pay and Google Pay buttons (placeholder)

## BLoC State Management

### Navigation BLoC
- **States**: `SplashState`, `OnboardingState`, `SignUpState`, `LoginState`
- **Events**: `NavigateToOnboarding`, `NavigateToSignUp`, `NavigateToLogin`, `NavigateToSplash`
- **Files**:
  - `lib/bloc/navigation/navigation_state.dart`
  - `lib/bloc/navigation/navigation_event.dart`
  - `lib/bloc/navigation/navigation_bloc.dart`

## Dependencies Added

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
```

## Navigation Flow

1. **Splash Screen** → (3 seconds) → **Onboarding Screen**
2. **Onboarding Screen** → (Get Started button) → **Sign Up Screen**
3. **Sign Up Screen** ↔ **Login Screen** (via buttons)
4. All screens can navigate back using the respective buttons

## API Integration Ready

The sign-up and login forms are prepared for API integration:
- Form validation is implemented
- Success/error handling is ready
- Placeholder methods for API calls are included
- SnackBar notifications for user feedback

## Assets Used

- `assets/images/Baground.png` - Splash screen background
- `assets/images/car.png` - Onboarding screen background

## Running the App

```bash
flutter pub get
flutter run
```

The app will start with the splash screen and automatically navigate through the flow as designed.
