import 'dart:async';
import 'dart:ui';

import 'package:coach_devanshi_doshi/core/blocs/auth/resend_sign_up_otp/resend_sign_up_otp_bloc.dart';
import 'package:coach_devanshi_doshi/core/services/loader_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../main.dart';
import '../../../core/blocs/auth/login/login_bloc.dart';
import '../../../core/blocs/auth/verify_otp/verify_otp_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/repository/auth_repo.dart';
import '../../../core/services/preference_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import '../profile/client_onboarding_introduction_screen.dart';
import 'connect_activity_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String type;
  final bool fromSignUp;
  final String countryCode;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber, this.fromSignUp = false, required this.countryCode, required this.type,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  late LoginBloc _loginBloc;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? otpError;

  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authRepo: AuthRepo());
    _startTimer();
  }

  void _startTimer() {
    _start = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _canResend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _resendCode() {
    if (_canResend) {
      // Add your resend logic here. For example:
      // BlocProvider.of<ResendSignUpOtpBloc>(context).add(UserResendSignUpOtpEvent(...));
      LoaderService.show(context);
      if(widget.fromSignUp) {
        BlocProvider.of<ResendSignUpOtpBloc>(context).add(UserResendSignUpOtpEvent(
          url: Urls.resendSignUpOtp,
          body: {
            "phone_code": widget.countryCode,
            "mobile": widget.phoneNumber,
          }
        ));
      } else {
        _loginBloc.add(UserLoginEvent(
          url: Urls.login,
          body: {
            "type": widget.type,
            "phone_code": widget.countryCode,
            "mobile": widget.phoneNumber,
          }
        ));
      }
    }
  }

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
      LoaderService.show(context);
      BlocProvider.of<VerifyOTPBloc>(context).add(UserVerifyOTPEvent(
        url: widget.fromSignUp ? Urls.signUpVerifyOTP : Urls.loginVerifyOTP,
        body: {
          if(!widget.fromSignUp) "type": widget.type,
          "phone_code": widget.countryCode,
          "mobile": widget.phoneNumber,
          "otp": _otpController.text
        }
      ));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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

    return MultiBlocListener(
      listeners: [
        // Verify
        BlocListener<VerifyOTPBloc, VerifyOTPState>(
          listener: (context, state) {
            if(state is VerifyOTPSuccess) {
              LoaderService.hide();
              showSnackBar(context: context, isError: false, message: state.model.message ?? "");
              AppPreferences.setBool(AppPreferences.isLogin, true);
              AppPreferences.setString(AppPreferences.accessToken, state.model.data?.token ?? "");

              if(state.model.data?.user?.isProfileCompleted ?? false) {
                navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
              } else {
                navigation.pushAndRemoveUntilSlideAnimation(context, ClientOnboardingIntroductionScreen());
              }

              // if(widget.fromSignUp) {
              //   navigation.pushSlideAnimation(context, ConnectActivityScreen(fromSignUp: widget.fromSignUp));
              // } else {
              //   navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
              // }
            } else if(state is VerifyOTPFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),

        // Resend
        BlocListener<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if(state is LoginSuccess) {
              LoaderService.hide();
              showSnackBar(context: context, isError: false, message: "OTP sent successfully!");
              _startTimer();
            } else if (state is LoginFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<ResendSignUpOtpBloc, ResendSignUpOtpState>(
          listener: (context, state) {
            if(state is ResendSignUpOtpSuccess) {
              LoaderService.hide();
              showSnackBar(context: context, isError: false, message: state.model.message ?? "");
              _startTimer();
            } else if(state is ResendSignUpOtpFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
      ],
      child: Scaffold(
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
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.phone,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        cursor: Container(
                          width: 3,
                          color: appColors.primary,
                          margin: EdgeInsets.symmetric(vertical: 13),
                        ),
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
                            onTap: _canResend ? _resendCode : null,
                            child: CommonText(
                              _canResend ? "Resend" : "Resend in 00:${_start.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _canResend ? appColors.primary : const Color(0xFF9A8687),
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
      ),
    );
  }
}
