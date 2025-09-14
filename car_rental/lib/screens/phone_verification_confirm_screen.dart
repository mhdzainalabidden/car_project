import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_event.dart';
import '../presentation/bloc/auth/auth_state.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';

class PhoneVerificationConfirmScreen extends StatefulWidget {
  final String phone;
  final String verifyToken;

  const PhoneVerificationConfirmScreen({
    super.key,
    required this.phone,
    required this.verifyToken,
  });

  @override
  State<PhoneVerificationConfirmScreen> createState() =>
      _PhoneVerificationConfirmScreenState();
}

class _PhoneVerificationConfirmScreenState
    extends State<PhoneVerificationConfirmScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String _verificationCode = '';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _updateVerificationCode();
  }

  void _updateVerificationCode() {
    _verificationCode = _controllers
        .map((controller) => controller.text)
        .join();
    if (_verificationCode.length == 4) {
      _verifyCode();
    }
  }

  void _verifyCode() {
    context.read<AuthBloc>().add(
      ConfirmPhoneVerificationRequested(
        code: _verificationCode,
        verifyToken: widget.verifyToken,
      ),
    );
  }

  void _onKeypadPressed(String digit) {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        _controllers[i].text = digit;
        _onDigitChanged(digit, i);
        break;
      }
    }
  }

  void _onBackspacePressed() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].text = '';
        if (i > 0) {
          _focusNodes[i - 1].requestFocus();
        }
        _updateVerificationCode();
        break;
      }
    }
  }

  String _maskPhoneNumber(String phone) {
    if (phone.length <= 4) return phone;
    final visibleDigits = phone.substring(phone.length - 4);
    final maskedDigits = '*' * (phone.length - 4);
    return '$maskedDigits$visibleDigits';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PhoneVerificationConfirmSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Phone verified successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to home screen
              context.read<NavigationBloc>().add(NavigateToHome());
            } else if (state is PhoneVerificationConfirmFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
              // Clear the verification code on error
              for (var controller in _controllers) {
                controller.clear();
              }
              _verificationCode = '';
            }
          },
          child: Column(
            children: [
              // Top Section - Scrollable
              Expanded(
                child: SingleChildScrollView(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter verification code',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We have send a Code to: ${_maskPhoneNumber(widget.phone)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Verification Code Input Fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) =>
                                        _onDigitChanged(value, index),
                                  ),
                                );
                              }),
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
                                        state is PhoneVerificationConfirmLoading
                                        ? null
                                        : _verificationCode.length == 4
                                        ? _verifyCode
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _verificationCode.length == 4
                                          ? Colors.black
                                          : Colors.grey[400],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child:
                                        state is PhoneVerificationConfirmLoading
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
                            const SizedBox(height: 16),
                            // Resend Code
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  // Implement resend logic
                                  context.read<AuthBloc>().add(
                                    RequestPhoneVerificationRequested(
                                      phone: widget.phone,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Didn\'t receive the OTP? Resend.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
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
              // Bottom Section - Fixed Keypad
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Keypad Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        if (index == 9) {
                          return const SizedBox(); // Empty space
                        } else if (index == 10) {
                          return _KeypadButton(
                            text: '0',
                            onPressed: () => _onKeypadPressed('0'),
                          );
                        } else if (index == 11) {
                          return _KeypadButton(
                            icon: Icons.backspace,
                            onPressed: _onBackspacePressed,
                          );
                        } else {
                          final digit = (index + 1).toString();
                          return _KeypadButton(
                            text: digit,
                            onPressed: () => _onKeypadPressed(digit),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  const _KeypadButton({this.text, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: text != null
                ? Text(
                    text!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Icon(icon, size: 24, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
