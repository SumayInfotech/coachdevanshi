import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import 'client_onboarding_screen.dart';

class ClientOnboardingIntroductionScreen extends StatelessWidget {
  const ClientOnboardingIntroductionScreen({super.key});

  void _onBack(BuildContext context) {
    bottomPageController.jumpToPage(BottomBarScreenIndex.home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBack(context);
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        appBar: CommonAppBar(
          appBarColor: appColors.transparent,
          leading: buildInkWell(
            onTap: () => _onBack(context),
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back,
              size: 24,
              color: appColors.neutral,
            ),
          ),
        ),
        title: CommonText(
          "Client Onboarding",
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
            fontFamily: "Playfair_Display",
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildHeroBanner(),
          const SizedBox(height: 24),
          _ArticleCard(
            category: "REFLECTION",
            title: "Understand You",
            description: "Tell us about your health, daily routine, food environment, mindset, and current goals. We look at you as a whole person so your dedicated dietitian understands your lived reality.",
          ),
          const SizedBox(height: 12),
          _ArticleCard(
            category: "HONESTY",
            title: "Be Honest & Compassionate",
            description: "Answer based on an ordinary week, not your most disciplined week. There are no right, wrong, or \"perfect\" answers—honest rhythm is the true bedrock of sustainable change.",
          ),
          const SizedBox(height: 12),
          _ArticleCard(
            category: "TAILORED CARE",
            title: "Personalised Plan",
            description: "Your reflections shape the gentle rituals, meal structures, metabolic benchmarks, and continuous check-in milestones crafted uniquely around your life.",
          ),
          const SizedBox(height: 16),
          _buildImportantMedicalNote(),
          const SizedBox(height: 32),
          CommonButton(
            name: "I'm Ready, Let's Begin",
            icon: Icons.arrow_forward_rounded,
            isIconFirst: false,
            imageSize: 16,
            btnColor: appColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            onTap: () {
              navigation.pushSlideAnimation(context, const ClientOnboardingScreen());
            },
          ),
          const SizedBox(height: 16),
          _buildTimeEstimation(),
          SizedBox(height: bottomPadding(context)),
        ],
      ),
    ));
  }

  Widget _buildHeroBanner() {
    return Container(
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative glow top right
          Positioned(
            top: -32,
            right: -32,
            child: Container(
              width: 176,
              height: 176,
              decoration: const BoxDecoration(
                color: Color(0x66D8E5BF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative glow bottom left
          Positioned(
            bottom: -48,
            left: -48,
            child: Container(
              width: 192,
              height: 192,
              decoration: const BoxDecoration(
                color: Color(0x4DFFDADB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        appImages.userAvatarPlaceholder, // Assuming this is the asset added recently
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CommonText(
                    "Welcome, Ananya",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Playfair_Display",
                        color: Color(0xFF292726),
                        height: 34 / 24,
                        letterSpacing: -0.675,
                      ),
                      children: [
                        const TextSpan(text: "Let’s build your "),
                        TextSpan(
                          text: "Health\nBlueprint",
                          style: TextStyle(
                            color: appColors.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantMedicalNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(appIcons.medicalNote, height: 16, width: 16, color: const Color(0xFF8B484D)),
              const SizedBox(width: 8),
              CommonText(
                "IMPORTANT MEDICAL NOTE",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1B1A),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CommonText(
            "Nutritional coaching supports holistic wellness and does not replace acute medical diagnosis, prescribing, or clinical treatment. Please update your clinical team through the app if your medication or medical status alters during care.",
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF534343),
              height: 21.13 / 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEstimation() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF6D615C),
          fontFamily: fontFamilyPlusJakartaSans,
          height: 18 / 13,
        ),
        children: [
          const TextSpan(text: "Takes "),
          const TextSpan(
            text: "12 - 15 minutes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: " total · Pause anytime"),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String category;
  final String title;
  final String description;

  const _ArticleCard({
    required this.category,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            category,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: appColors.primary,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          CommonText(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "Playfair_Display",
              color: const Color(0xFF292726),
              letterSpacing: -0.675,
            ),
          ),
          const SizedBox(height: 12),
          CommonText(
            description,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF6D615C),
              height: 18 / 13,
            ),
          ),
        ],
      ),
    );
  }
}
