import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'sign_up_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {

  late LoginBloc _loginBloc;

  final TextEditingController _phoneController = TextEditingController();
  String selectedCountryCode = "+91";

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authRepo: AuthRepo());
  }

  void _sendCode() {
    if(validation()){
      LoaderService.show(context);
      _loginBloc.add(UserLoginEvent(
        url: Urls.login,
        body: {
          "type": "mobile",
          "phone_code": selectedCountryCode,
          "mobile": _phoneController.text,
        }
      ));
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
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if(state is LoginSuccess) {
          LoaderService.hide();
          showSnackBar(context: context, isError: false, message: state.model.message ?? "");
          navigation.pushSlideAnimation(
            context,
            OtpVerificationScreen(
              type: "mobile",
              phoneNumber: _phoneController.text,
              countryCode: selectedCountryCode,
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
                                  fontSize: 14,
                                  color: Color(0xFF2B2B2B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
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
                      onTap: () async {
                        LoaderService.show(context);
                        final data = await AuthServices.signInWithGoogle();
                        if(data != null) {
                          BlocProvider.of<SocialLoginBloc>(context).add(UserSocialLoginEvent(
                            url: Urls.socialLogin,
                            body: {
                              "type": "google",
                              "name": data.name,
                              "email": data.email,
                            }
                          ));
                        } else {
                          LoaderService.hide();
                          showSnackBar(context: context, isError: true, message: "Sign-in was cancelled. You can try again.");
                        }
                      },
                    ),
                    if(Platform.isIOS) ...[
                      const SizedBox(width: 12),
                      _buildSocialButton(
                        iconPath: appIcons.apple,
                        title: "Apple",
                        onTap: () async {
                          LoaderService.show(context);
                          final data = await AuthServices.signInWithApple();
                          if(data != null) {
                            BlocProvider.of<SocialLoginBloc>(context).add(UserSocialLoginEvent(
                              url: Urls.socialLogin,
                              body: {
                                "type": "apple",
                                "name": data.name,
                                "email": data.email,
                              }
                            ));
                          } else {
                            LoaderService.hide();
                            showSnackBar(context: context, isError: true, message: "Sign-in was cancelled. You can try again.");
                          }
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
