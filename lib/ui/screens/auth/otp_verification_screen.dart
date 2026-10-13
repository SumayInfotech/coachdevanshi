import 'dart:ui';
import 'package:coach_devanshi_doshi/core/services/preference_service.dart';
import 'package:coach_devanshi_doshi/ui/screens/auth/connect_activity_screen.dart';
import 'package:coach_devanshi_doshi/ui/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../bottom_bar_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final bool fromSignUp;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber, this.fromSignUp = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {


  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? otpError;

  bool validation() {
    if (_otpController.text.length < 6) {
      otpError = "Please enter a valid 6-digit verification code";
      setState(() {});
      return false;
    }

    otpError = null;
    setState(() {});
    return true;
  }

  void _verifyAndContinue() {
    if (validation()) {
      if(widget.fromSignUp) {
        navigation.pushSlideAnimation(context, ConnectActivityScreen(fromSignUp: widget.fromSignUp));
      } else {
        AppPreferences.setBool(AppPreferences.isLogin, true);
        navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Pinput theme definitions using consolidated appColors
    final defaultPinTheme = PinTheme(
      width: 43,
      height: 56,
      textStyle: const TextStyle(
        fontFamily: fontFamilyPlusJakartaSans,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1D1B1A),
        height: 1.18,
        letterSpacing: -0.64,
      ),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFFFDADB).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
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
    );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration!.copyWith(
    //     color: appColors.tertiary,
    //     border: Border.all(color: appColors.borderOutline, width: 1),
    //   ),
    // );
    //
    // final errorPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration!.copyWith(
    //     color: appColors.red.withValues(alpha: 0.05),
    //     border: Border.all(color: appColors.red, width: 1.5),
    //   ),
    // );

    return Scaffold(
      backgroundColor: appColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: CommonAppBar(
              appBarColor: appColors.bgColor.withValues(alpha: 0.8),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B1A)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const CommonText(
                "Verification",
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
                  color: Colors.black.withValues(alpha: 0.04),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Heading
              const CommonText(
                "Enter verification code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1B1A),
                  letterSpacing: -0.7,
                ),
                fontFamily: 'serif',
              ),
              const SizedBox(height: 16),
              // Subtitle
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const CommonText(
                    "We have sent a 6-digit code to ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF534343),
                    ),
                  ),
                  CommonText(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Edit button
              GestureDetector(
                onTap: () {
                  navigation.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      "Edit",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: appColors.primary,
                        letterSpacing: 0.24,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: appColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Main Card Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    const CommonText(
                      "Enter 6-Digit Code",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF534343),
                        letterSpacing: 0.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Pinput(
                      length: 6,
                      controller: _otpController,
                      focusNode: _focusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: appColors.red),
                        ),
                      ),
                      forceErrorState: otpError != null,
                      onChanged: (value) {
                        if (otpError != null) {
                          validation();
                        }
                      },
                    ),
                    if (otpError != null) ...[
                      const SizedBox(height: 8),
                      CommonText(
                        otpError!,
                        style: TextStyle(
                          color: appColors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF534343),
                        ),
                        const SizedBox(width: 6),
                        const CommonText(
                          "Didn't receive a code?",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF534343),
                            letterSpacing: 0.33,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Resend code logic
                          },
                          child: CommonText(
                            "Resend",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: appColors.primary,
                              letterSpacing: 0.24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CommonButton(
                      name: "Verify & Continue",
                      onTap: _verifyAndContinue,
                      icon: Icons.arrow_forward_rounded,
                      isIconFirst: false,
                      btnColor: appColors.primary,
                      fontColor: appColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      radius: 999,
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
