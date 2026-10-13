import 'package:coach_devanshi_doshi/ui/widgets/common_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/utils.dart';
import '../../../main.dart';
import '../../widgets/common_web_view.dart';
import '../auth/phone_login_screen.dart';
import '../auth/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    iconPath: appIcons.apple,
                    title: "Continue with Apple",
                    onTap: () {},
                  ),
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
    );
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
