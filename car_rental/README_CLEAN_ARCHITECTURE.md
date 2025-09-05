# Clean Architecture Implementation

This project follows Uncle Bob's Clean Architecture principles with proper separation of concerns across different layers.

## Architecture Overview

```
lib/
├── domain/                    # Business Logic Layer
│   ├── entities/             # Core business objects
│   │   ├── user.dart
│   │   └── auth_result.dart
│   ├── repositories/         # Repository interfaces
│   │   └── auth_repository.dart
│   └── usecases/            # Business use cases
│       ├── sign_up_usecase.dart
│       ├── login_usecase.dart
│       └── social_login_usecase.dart
├── data/                     # Data Layer
│   ├── datasources/         # Data sources (API, Local)
│   │   ├── auth_remote_datasource.dart
│   │   ├── auth_remote_datasource_impl.dart
│   │   ├── auth_local_datasource.dart
│   │   └── auth_local_datasource_impl.dart
│   └── repositories/        # Repository implementations
│       └── auth_repository_impl.dart
├── presentation/            # Presentation Layer
│   └── bloc/               # State management
│       └── auth/
│           ├── auth_bloc.dart
│           ├── auth_event.dart
│           └── auth_state.dart
├── injection/              # Dependency Injection
│   └── injection_container.dart
└── screens/               # UI Layer
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── signup_screen.dart
    └── login_screen.dart
```

## Layer Responsibilities

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (User, AuthResult)
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic and rules

**Dependencies**: None (Pure Dart)

### 2. Data Layer (Data Access)
- **Data Sources**: Concrete implementations for API and local storage
- **Repository Implementations**: Bridge between domain and data layers

**Dependencies**: Domain layer only

### 3. Presentation Layer (UI Logic)
- **BLoC**: State management and UI logic
- **Screens**: UI components

**Dependencies**: Domain layer only

### 4. Injection Layer (Dependency Management)
- **Dependency Container**: Manages object creation and dependencies

**Dependencies**: All layers

## Key Principles Applied

### 1. Dependency Inversion
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Example: `AuthBloc` depends on `AuthRepository` interface, not implementation

### 2. Single Responsibility
- Each class has one reason to change
- `SignUpUseCase` only handles sign-up business logic
- `AuthRemoteDataSource` only handles API calls

### 3. Open/Closed Principle
- Open for extension, closed for modification
- Easy to add new authentication methods without changing existing code

### 4. Interface Segregation
- Clients shouldn't depend on interfaces they don't use
- Separate interfaces for different concerns

## Data Flow

```
UI Event → BLoC → Use Case → Repository → Data Source → API/Local Storage
                ↓
UI State ← BLoC ← Use Case ← Repository ← Data Source ← API/Local Storage
```

## Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Changes in one layer don't affect others
3. **Scalability**: Easy to add new features and modify existing ones
4. **Reusability**: Business logic can be reused across different UI implementations
5. **Flexibility**: Easy to swap implementations (e.g., different data sources)

## Dependencies

- `get_it`: Dependency injection
- `shared_preferences`: Local storage
- `http`: API calls
- `flutter_bloc`: State management
- `equatable`: Value equality

## Usage Example

```dart
// In your widget
context.read<AuthBloc>().add(
  SignUpRequested(
    fullName: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
    country: 'USA',
  ),
);

// Listen to state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // Handle success
    } else if (state is AuthFailure) {
      // Handle error
    }
  },
  child: YourWidget(),
)
```

## Testing Strategy

Each layer can be tested independently:

1. **Domain Layer**: Unit tests for use cases and entities
2. **Data Layer**: Unit tests for repository implementations and data sources
3. **Presentation Layer**: Widget tests and BLoC tests
4. **Integration Tests**: End-to-end testing of complete flows

## Future Enhancements

1. Add more use cases (forgot password, profile management)
2. Implement caching strategies
3. Add offline support
4. Implement proper error handling and retry mechanisms
5. Add analytics and logging
