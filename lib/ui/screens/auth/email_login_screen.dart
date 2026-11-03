import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/auth/login/login_bloc.dart';
import '../../../core/blocs/auth/social_login/social_login_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/repository/auth_repo.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'otp_verification_screen.dart';
import 'phone_login_screen.dart';
import 'sign_up_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  late LoginBloc _loginBloc;

  final TextEditingController _emailController = TextEditingController();
  String? emailError;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authRepo: AuthRepo());
  }

  void _sendCode() {
    if (validation()) {
      LoaderService.show(context);
      _loginBloc.add(
        UserLoginEvent(
          url: Urls.login,
          body: {
            "type": "email",
            "email": _emailController.text.trim(),
          },
        ),
      );
    }
  }

  bool validation() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      emailError = "Please enter your email address";
      setState(() {});
      return false;
    }

    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

    if (!emailValid) {
      emailError = "Please enter a valid email address";
      setState(() {});
      return false;
    }

    emailError = null;
    setState(() {});
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginSuccess) {
          LoaderService.hide();
          showSnackBar(context: context, isError: false, message: state.model.message ?? "");
          navigation.pushSlideAnimation(
            context,
            OtpVerificationScreen(
              type: "email",
              email: _emailController.text.trim(),
              phoneNumber: _emailController.text.trim(),
            ),
          );
        } else if (state is LoginFailed) {
          LoaderService.hide();
          showSnackBar(context: context, isError: true, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const CommonText(
                  "Enter your email address",
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
                        label: "Email Address",
                        controller: _emailController,
                        hint: "name@example.com",
                        keyboardType: TextInputType.emailAddress,
                        error: emailError,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                appIcons.email,
                                width: 20,
                                height: 20,
                                color: appColors.primary,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.email_outlined,
                                    size: 20,
                                    color: appColors.primary,
                                  );
                                },
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
                          if (emailError != null) validation();
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
                      iconPath: appIcons.phone,
                      title: "Phone",
                      onTap: () {
                        navigation.pushReplaceSlideAnimation(context, const PhoneLoginScreen());
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildSocialButton(
                      iconPath: appIcons.google,
                      title: "Google",
                      onTap: () async {
                        LoaderService.show(context);
                        final data = await AuthServices.signInWithGoogle();
                        buildSocialLogin(data, "google");
                      },
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(width: 12),
                      _buildSocialButton(
                        iconPath: appIcons.apple,
                        title: "Apple",
                        onTap: () async {
                          LoaderService.show(context);
                          final data = await AuthServices.signInWithApple();
                          buildSocialLogin(data, "apple");
                        },
                      ),
                    ],
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigation.pushSlideAnimation(context, const SignUpScreen());
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
      ),
    );
  }

  void buildSocialLogin(AuthUserData? data, String type) {
    if (data != null) {
      BlocProvider.of<SocialLoginBloc>(context).add(
        UserSocialLoginEvent(
          url: Urls.socialLogin,
          body: {
            "type": type,
            "name": data.name,
            "email": data.email,
          },
        ),
      );
    } else {
      LoaderService.hide();
      showSnackBar(context: context, isError: true, message: "Sign-in was cancelled. You can try again.");
    }
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
