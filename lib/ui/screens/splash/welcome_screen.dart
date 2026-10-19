import 'dart:io';

import 'package:coach_devanshi_doshi/core/blocs/auth/social_login/social_login_bloc.dart';
import 'package:coach_devanshi_doshi/ui/screens/bottom_bar_screen.dart';
import 'package:coach_devanshi_doshi/ui/screens/profile/client_onboarding_introduction_screen.dart';
import 'package:coach_devanshi_doshi/ui/widgets/common_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/loader_service.dart';
import '../../../core/services/preference_service.dart';
import '../../../main.dart';
import '../../widgets/common_web_view.dart';
import '../auth/phone_login_screen.dart';
import '../auth/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    _initAuthServices();
  }

  Future<void> _initAuthServices() async {
    await AuthServices.initialize(); // Initialize Google, Apple Sign-In
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocialLoginBloc, SocialLoginState>(
      listener: (context, state) {
        if(state is SocialLoginSuccess) {
          LoaderService.hide();
          AppPreferences.setBool(AppPreferences.isLogin, true);
          AppPreferences.setString(AppPreferences.accessToken, state.model.data?.token ?? "");
          showSnackBar(context: context, isError: false, message: state.model.message ?? "");
          if(state.model.data?.user?.isProfileCompleted ?? false) {
            navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
          } else {
            navigation.pushAndRemoveUntilSlideAnimation(context, ClientOnboardingIntroductionScreen());
          }
        } else if(state is SocialLoginFailed) {
          LoaderService.hide();
          showSnackBar(context: context, isError: true, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      Color(0xA6EBB2B9),
                      Color(0x59F8CED4),
                      Color(0x00F8CED4),
                    ],
                    stops: [0.0, 0.45, 0.75],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    const Text(
                      "Welcome!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'serif',
                        color: Color(0xFF2B2B2B),
                      ),
                    ),
                    const Spacer(flex: 1),
                    _buildLoginButton(
                      iconPath: appIcons.phone,
                      title: "Continue with Phone",
                      onTap: () {
                        navigation.pushSlideAnimation(context, const PhoneLoginScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLoginButton(
                      iconPath: appIcons.email,
                      title: "Continue with Email",
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildLoginButton(
                      iconPath: appIcons.google,
                      title: "Continue with Google",
                      onTap: () async {
                        LoaderService.show(context);
                        final data = await AuthServices.signInWithGoogle();
                        buildSocialLogin(data, "google");
                      },
                    ),
                    if(Platform.isIOS) ...[
                      const SizedBox(height: 16),
                      _buildLoginButton(
                        iconPath: appIcons.apple,
                        title: "Continue with Apple",
                        onTap: () async {
                          LoaderService.show(context);
                          final data = await AuthServices.signInWithApple();
                          buildSocialLogin(data, "apple");
                        },
                      ),
                    ],
                    const Spacer(flex: 2),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
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
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                navigation.pushSlideAnimation(context, SignUpScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const CommonText(
                      "By creating an account, you agree to our",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B8B8B),
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
                              fontSize: 12,
                              color: Color(0xFF4A4A4A),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const CommonText(
                          " and ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B8B8B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigation.pushSlideAnimation(context, CommonWebView(title: "Privacy Policy", url: "https://www.google.com/"));
                          },
                          child: const CommonText(
                            "Privacy Policy",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A4A4A),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const CommonText(
                          ".",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B8B8B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildSocialLogin(AuthUserData? data, String type) {
    if(data != null) {
      BlocProvider.of<SocialLoginBloc>(context).add(UserSocialLoginEvent(
        url: Urls.socialLogin,
        body: {
          "type": type,
          "name": data.name,
          "email": data.email,
        }
      ));
    } else {
      LoaderService.hide();
      showSnackBar(context: context, isError: true, message: "Sign-in was cancelled. You can try again.");
    }
  }

  Widget _buildLoginButton({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFFAF4F5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CommonText(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Image.asset(
              appIcons.forward,
              width: 14,
              height: 14,
              color: const Color(0xFFD4C7C8),
            ),
          ],
        ),
      ),
    );
  }
}
