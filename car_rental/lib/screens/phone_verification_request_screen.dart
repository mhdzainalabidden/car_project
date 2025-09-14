import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_event.dart';
import '../presentation/bloc/auth/auth_state.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import 'phone_verification_confirm_screen.dart';

class PhoneVerificationRequestScreen extends StatefulWidget {
  final String? initialPhone;
  final String? initialCountryCode;

  const PhoneVerificationRequestScreen({
    super.key,
    this.initialPhone,
    this.initialCountryCode,
  });

  @override
  State<PhoneVerificationRequestScreen> createState() =>
      _PhoneVerificationRequestScreenState();
}

class _PhoneVerificationRequestScreenState
    extends State<PhoneVerificationRequestScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedCountry = 'US';
  String _countryCode = '+1';

  final Map<String, String> _countries = {
    'US': '+1',
    'UK': '+44',
    'CA': '+1',
    'AU': '+61',
    'DE': '+49',
    'FR': '+33',
    'IT': '+39',
    'ES': '+34',
    'JP': '+81',
    'KR': '+82',
    'CN': '+86',
    'IN': '+91',
    'BR': '+55',
    'MX': '+52',
    'RU': '+7',
    'EG': '+20',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null) {
      _phoneController.text = widget.initialPhone!;
    }
    if (widget.initialCountryCode != null) {
      _countryCode = widget.initialCountryCode!;
      // Find the country key for the country code
      _countries.forEach((key, value) {
        if (value == widget.initialCountryCode) {
          _selectedCountry = key;
        }
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _getFlagEmoji(String countryCode) {
    switch (countryCode) {
      case 'US':
        return '🇺🇸';
      case 'UK':
        return '🇬🇧';
      case 'CA':
        return '🇨🇦';
      case 'AU':
        return '🇦🇺';
      case 'DE':
        return '🇩🇪';
      case 'FR':
        return '🇫🇷';
      case 'IT':
        return '🇮🇹';
      case 'ES':
        return '🇪🇸';
      case 'JP':
        return '🇯🇵';
      case 'KR':
        return '🇰🇷';
      case 'CN':
        return '🇨🇳';
      case 'IN':
        return '🇮🇳';
      case 'BR':
        return '🇧🇷';
      case 'MX':
        return '🇲🇽';
      case 'RU':
        return '🇷🇺';
      case 'EG':
        return '🇪🇬';
      default:
        return '🇺🇸';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print('Phone verification state: $state');
            if (state is PhoneVerificationRequestSuccess) {
              print(
                'Phone verification success: ${state.result.phone}, ${state.result.verifyToken}',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhoneVerificationConfirmScreen(
                    phone: state.result.phone!,
                    verifyToken: state.result.verifyToken!,
                  ),
                ),
              );
            } else if (state is PhoneVerificationRequestFailure) {
              print('Phone verification failure: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // App Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                const SizedBox(height: 60),
                // Main Content Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verify your phone number',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We have sent you an SMS with a code to number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Country Selection
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCountry,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.flag, color: Colors.grey),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ),
                            items: _countries.keys.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Row(
                                  children: [
                                    Text(
                                      _getFlagEmoji(country),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(country),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCountry = newValue;
                                  _countryCode = _countries[newValue]!;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Phone Number Input
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixText: '$_countryCode ',
                            prefixStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        // Continue Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed:
                                    state is PhoneVerificationRequestLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          final fullPhoneNumber =
                                              '$_countryCode${_phoneController.text}';
                                          print(
                                            'Requesting verification for phone: $fullPhoneNumber',
                                          );
                                          context.read<AuthBloc>().add(
                                            RequestPhoneVerificationRequested(
                                              phone: fullPhoneNumber,
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: state is PhoneVerificationRequestLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Back to Login
                TextButton(
                  onPressed: () {
                    context.read<NavigationBloc>().add(NavigateToLogin());
                  },
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
