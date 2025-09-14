import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_event.dart';
import '../presentation/bloc/auth/auth_state.dart';
import '../domain/entities/country.dart';
import '../domain/usecases/get_countries_usecase.dart';
import '../injection/injection_container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  int? _selectedCountryId;
  bool _obscurePassword = true;
  bool _isLoadingCountries = true;
  String? _countriesError;
  List<Country> _countries = [];
  int _currentPage = 1;
  int _lastPage = 1;
  int _totalCountries = 0;
  late GetCountriesUseCase _getCountriesUseCase;

  @override
  void initState() {
    super.initState();
    _getCountriesUseCase = sl<GetCountriesUseCase>();
    _loadCountries();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries({int page = 1}) async {
    try {
      setState(() {
        _isLoadingCountries = true;
        _countriesError = null;
        // Clear selected country when changing pages to avoid dropdown errors
        if (page != _currentPage) {
          _selectedCountryId = null;
        }
      });

      final response = await _getCountriesUseCase(page: page);
      setState(() {
        _countries = response.countries;
        _currentPage = response.currentPage;
        _lastPage = response.lastPage;
        _totalCountries = response.total;
        _isLoadingCountries = false;
      });
    } catch (e) {
      setState(() {
        _countriesError = e.toString();
        _isLoadingCountries = false;
      });
    }
  }

  void _goToFirstPage() {
    if (_currentPage > 1) {
      _loadCountries(page: 1);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _loadCountries(page: _currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _lastPage) {
      _loadCountries(page: _currentPage + 1);
    }
  }

  void _goToLastPage() {
    if (_currentPage < _lastPage) {
      _loadCountries(page: _lastPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Signup auth state: $state');
        if (state is AuthSuccess) {
          print('Signup successful, navigating to phone verification');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Sign up successful! Please verify your phone number.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to phone verification
          context.read<NavigationBloc>().add(
            NavigateToPhoneVerification(
              phone: _phoneController.text.trim(),
              verifyToken: '', // Will be set when verification is requested
            ),
          );
        } else if (state is AuthFailure) {
          print('Signup failed: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo and App Name
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Qent',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Title
                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Email Address
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Country Dropdown
                      if (_isLoadingCountries)
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_countriesError != null)
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Failed to load countries',
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _loadCountries,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        DropdownButtonFormField<int>(
                          value:
                              _countries.any(
                                (country) => country.id == _selectedCountryId,
                              )
                              ? _selectedCountryId
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Select Country',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _countries.map((Country country) {
                            return DropdownMenuItem<int>(
                              value: country.id,
                              child: Text(country.country),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedCountryId = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value <= 0) {
                              return 'Please select your country';
                            }
                            return null;
                          },
                        ),
                      // Pagination Controls
                      if (!_isLoadingCountries &&
                          _countriesError == null &&
                          _lastPage > 1)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              // Page Info
                              Text(
                                'Page $_currentPage of $_lastPage (Total: $_totalCountries countries)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Note: Changing pages will clear your country selection',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Pagination Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // First Page
                                  IconButton(
                                    onPressed: _currentPage > 1
                                        ? _goToFirstPage
                                        : null,
                                    icon: const Icon(Icons.first_page),
                                    iconSize: 20,
                                    color: _currentPage > 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  // Previous Page
                                  IconButton(
                                    onPressed: _currentPage > 1
                                        ? _goToPreviousPage
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                    iconSize: 20,
                                    color: _currentPage > 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  // Page Number
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '$_currentPage',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  // Next Page
                                  IconButton(
                                    onPressed: _currentPage < _lastPage
                                        ? _goToNextPage
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                    iconSize: 20,
                                    color: _currentPage < _lastPage
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  // Last Page
                                  IconButton(
                                    onPressed: _currentPage < _lastPage
                                        ? _goToLastPage
                                        : null,
                                    icon: const Icon(Icons.last_page),
                                    iconSize: 20,
                                    color: _currentPage < _lastPage
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<NavigationBloc>().add(
                              NavigateToLogin(),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login Link
                      const Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'Login.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          countryId: _selectedCountryId ?? 0,
        ),
      );
    }
  }
}
