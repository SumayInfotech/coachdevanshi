import 'package:coach_devanshi_doshi/ui/screens/auth/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _sendCode() {
    if(validation()){
      navigation.pushSlideAnimation(
        context,
        OtpVerificationScreen(phoneNumber: "+91 ${_phoneController.text}"),
      );
    }
  }

  String? phoneError;
  bool validation() {
    if (_phoneController.text.length < 10) {
      phoneError = "Please enter a valid 10-digit mobile number";
      setState(() { });
      return false;
    }

    phoneError = null;
    setState(() { });
    return true;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const CommonText(
                "Enter your phone number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2B2B2B),
                ),
                fontFamily: 'serif',
              ),
              const SizedBox(height: 8),
              const CommonText(
                "We will send OTP for verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B6B6B),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextField(
                      label: "Mobile Number",
                      controller: _phoneController,
                      hint: "98765 43210",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      error: phoneError,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "+91",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2B2B2B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        validation();
                      },
                    ),
                    const SizedBox(height: 24),
                    CommonButton(
                      name: "Send Verification Code",
                      onTap: _sendCode,
                      icon: Icons.arrow_forward_rounded,
                      isIconFirst: false,
                      btnColor: const Color(0xFF8B484D),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CommonText(
                      "OR Login with",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSocialButton(
                    iconPath: appIcons.email,
                    title: "Email",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _buildSocialButton(
                    iconPath: appIcons.google,
                    title: "Google",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _buildSocialButton(
                    iconPath: appIcons.apple,
                    title: "Apple",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B6B6B),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: const TextStyle(
                          color: Color(0xFFA2666A),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          navigation.pushSlideAnimation(context, SignUpScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              CommonText(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
