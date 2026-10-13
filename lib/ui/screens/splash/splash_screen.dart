import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/services/preference_service.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _logoController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _fadeAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeInOut,);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero,).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic,),
    );

    _logoController.forward();
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 700), () {
          if(mounted) {
            if (AppPreferences.getBool(AppPreferences.isLogin)) {
              navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
            } else {
              navigation.pushAndRemoveUntilSlideAnimation(context, WelcomeScreen());
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
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
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomCenter,
                  radius: 1.2,
                  colors: [
                    Color(0xA6CEE0BC),
                    Color(0x59DEECD0),
                    Color(0x00DEECD0),
                  ],
                  stops: [0.0, 0.5, 0.75],
                ),
              ),
            ),
          ),
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(appImages.appLogo, width: 220, fit: BoxFit.contain),
                        const SizedBox(height: 20),
                        CommonText(
                          "Devanshi Doshi",
                          textAlign: .center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontFamily: 'serif',
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(appImages.splashImage, width: 220, fit: BoxFit.contain),
                        const SizedBox(height: 15),
                        CommonText(
                          "HOLISTIC INCH-LOSS COACH",
                          textAlign: .center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA2666A),
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
