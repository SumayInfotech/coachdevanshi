import 'dart:ui';

import 'package:coach_devanshi_doshi/core/constants/utils.dart';
import 'package:coach_devanshi_doshi/core/services/loader_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/auth/sign_up/sign_up_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/repository/auth_repo.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/common_web_view.dart';
import 'otp_verification_screen.dart';
import 'phone_login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late SignUpBloc _signUpBloc;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String selectedCountryCode = "+91";

  String? nameError;
  String? phoneError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc(authRepo: AuthRepo());
  }

  bool validation() {
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      nameError = "Please enter your full name";
      isValid = false;
    } else {
      nameError = null;
    }

    if (_phoneController.text.length < 10) {
      phoneError = "Please enter a valid 10-digit mobile number";
      isValid = false;
    } else {
      phoneError = null;
    }

    if (_emailController.text.trim().isEmpty || !_emailController.text.contains("@")) {
      emailError = "Please enter a valid email address";
      isValid = false;
    } else {
      emailError = null;
    }

    setState(() {});
    return isValid;
  }

  void _createAccountAndVerify() {
    if (validation()) {
      LoaderService.show(context);
      _signUpBloc.add(UserSignUpEvent(
        url: Urls.signUp,
        body: {
          "name" : _nameController.text,
          "phone_code" : selectedCountryCode,
          "mobile" : _phoneController.text,
          "email" : _emailController.text,
        }
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      bloc: _signUpBloc,
      listener: (context, state) {
        if(state is SignUpSuccess) {
          LoaderService.hide();
          showSnackBar(context: context, isError: false, message: state.model.message ?? "");
          navigation.pushSlideAnimation(
            context,
            OtpVerificationScreen(
              fromSignUp: true,
              type: "sign-up",
              phoneNumber: _phoneController.text,
              countryCode: selectedCountryCode,
            ),
          );
        } else if(state is SignUpFailed) {
          LoaderService.hide();
          showSnackBar(context: context, isError: true, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor, // #FEF8F6
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: CommonAppBar(
                appBarColor: appColors.bgColor.withValues(alpha: 0.85),
                centerTitle: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B1A)),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const CommonText(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                  fontFamily: 'serif',
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.03),
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    const CommonText(
                      "BEGIN YOUR JOURNEY",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B484D),
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const CommonText(
                      "Create your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D1B1A),
                        letterSpacing: -0.28,
                      ),
                      fontFamily: 'serif',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      CommonTextField(
                        label: "Full Name",
                        controller: _nameController,
                        isRequired: false,
                        hint: "Enter full name",
                        error: nameError,
                        borderColor: Colors.transparent,
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF857373), size: 20),
                        onChanged: (value) {
                          if (nameError != null) validation();
                        },
                        mandatoryStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF534343),
                          letterSpacing: 0.55,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mobile Contact Field
                      CommonTextField(
                        label: "Mobile Contact",
                        controller: _phoneController,
                        isRequired: false,
                        hint: "Enter mobile no.",
                        keyboardType: TextInputType.phone,
                        error: phoneError,
                        borderColor: Colors.transparent,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryCodePicker(
                                onChanged: (countryCode) {
                                  selectedCountryCode = countryCode.dialCode ?? "+91";
                                },
                                initialSelection: 'IN',
                                favorite: const ['+91', 'IN'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                flagWidth: 25,
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D1B1A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 24,
                                width: 1,
                                color: const Color(0xFFE7E1DF),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          if (phoneError != null) validation();
                        },
                        mandatoryStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF534343),
                          letterSpacing: 0.55,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Email Address Field
                      CommonTextField(
                        label: "Email Address",
                        controller: _emailController,
                        isRequired: false,
                        hint: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        error: emailError,
                        borderColor: Colors.transparent,
                        prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF857373), size: 20),
                        onChanged: (value) {
                          if (emailError != null) validation();
                        },
                        mandatoryStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF534343),
                          letterSpacing: 0.55,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      CommonButton(
                        name: "Create Account & Verify",
                        onTap: _createAccountAndVerify,
                        icon: Icons.arrow_forward_rounded,
                        isIconFirst: false,
                        btnColor: appColors.primary,
                        fontColor: appColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        radius: 999,
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: CommonText(
                          "We will send an OTP to verify your mobile number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF534343),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFEDE7E5),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CommonText(
                        "OR Sign up with",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF857373),
                          letterSpacing: 0.55,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFEDE7E5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                const SizedBox(height: 48),
                // Footer Log in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CommonText(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF534343),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigation.pushSlideAnimation(context, const PhoneLoginScreen());
                      },
                      child: CommonText(
                        "Log in",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: appColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Legal Note
                const CommonText(
                  "By creating an account, you agree to our",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF857373),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigation.pushSlideAnimation(context, CommonWebView(title: "Terms of Service", url: "https://www.google.com/"));
                      },
                      child: const CommonText(
                        "Terms of Service",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1D1B1A),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const CommonText(
                      " and ",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF857373),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigation.pushSlideAnimation(context, CommonWebView(title: "Privacy Policy", url: "https://www.google.com/"));
                      },
                      child: const CommonText(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1D1B1A),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const CommonText(
                      ".",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF857373),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF292726).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            CommonText(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1D1B1A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
