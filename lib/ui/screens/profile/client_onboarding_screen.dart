import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import 'food_digestion_intake_screen.dart';
import 'goals_starting_point_screen.dart';
import 'health_safety_intake_screen.dart';
import 'lifestyle_coaching_fit_screen.dart';
import 'profile_program_selection_screen.dart';

class ClientOnboardingScreen extends StatelessWidget {
  const ClientOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      appBar: CommonAppBar(
        appBarColor: appColors.transparent,
        leading: buildInkWell(
          onTap: () => navigation.pop(context),
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
          _buildProgressBanner(),
          const SizedBox(height: 24),
          _ChapterCard(
            chapterNumber: "CHAPTER 01",
            title: "Profile & Program",
            subtitle: "Gut Reset & Digestive Ease",
            status: "Complete",
            isComplete: true,
            icon: appIcons.profileProgram,
            iconBgColor: const Color(0xFFD8E5BF),
            iconColor: const Color(0xFF5B6749),
            buttonText: "Edit",
            isPrimaryAction: false,
            onTapButton: () => navigation.pushSlideAnimation(context, ProfileProgramSelectionScreen()),
          ),
          const SizedBox(height: 12),
          _ChapterCard(
            chapterNumber: "CHAPTER 02",
            title: "Goals & Starting Point",
            subtitle: "Better digestion & energy vitality",
            status: "Pending",
            isComplete: false,
            icon: appIcons.goalsStartingPoint,
            iconBgColor: const Color(0xFFFFDADB),
            iconColor: const Color(0xFF3A0910),
            buttonText: "Start",
            isPrimaryAction: true,
            onTapButton: () => navigation.pushSlideAnimation(context, GoalsStartingPointScreen()),
          ),
          const SizedBox(height: 12),
          _ChapterCard(
            chapterNumber: "CHAPTER 03",
            title: "Relevant Health & Safety",
            subtitle: "Acid reflux · Physician cleared",
            status: "Complete",
            isComplete: true,
            icon: appIcons.relevantHealthSafety,
            iconBgColor: const Color(0xFFD8E5BF),
            iconColor: const Color(0xFF5B6749),
            buttonText: "Edit",
            isPrimaryAction: false,
            onTapButton: () => navigation.pushSlideAnimation(context, HealthSafetyIntakeScreen()),
          ),
          const SizedBox(height: 12),
          _ChapterCard(
            chapterNumber: "CHAPTER 04",
            title: "Food & Digestion",
            subtitle: "Plant-forward · Structured rhythm",
            status: "Complete",
            isComplete: true,
            icon: appIcons.foodDigestion,
            iconBgColor: const Color(0xFFFFDADB),
            iconColor: const Color(0xFF3A0910),
            buttonText: "Edit",
            isPrimaryAction: false,
            onTapButton: () => navigation.pushSlideAnimation(context, FoodDigestionIntakeScreen()),
          ),
          const SizedBox(height: 12),
          _ChapterCard(
            chapterNumber: "CHAPTER 05",
            title: "Lifestyle & Coaching Fit",
            subtitle: "7.5k steps · 7.5h restorative sleep",
            status: "Complete",
            isComplete: true,
            icon: appIcons.lifestyleCoaching,
            iconBgColor: const Color(0xFFD8E5BF),
            iconColor: const Color(0xFF5B6749),
            buttonText: "Edit",
            isPrimaryAction: false,
            onTapButton: () => navigation.pushSlideAnimation(context, LifestyleCoachingFitScreen()),
          ),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Return to Home",
            icon: Icons.arrow_forward_rounded,
            isIconFirst: false,
            imageSize: 16,
            btnColor: appColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            onTap: () => navigation.pop(context),
          ),
          SizedBox(height: bottomPadding(context)),
        ],
      ),
    );
  }

  Widget _buildProgressBanner() {
    return Container(
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withOpacity(0.05),
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
                color: Color(0x66D8E5BF), // approx 0.4 opacity
                shape: BoxShape.circle,
              ),
              // Use ImageFilter or BoxShadow for blur if needed, keeping it simple here
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
                color: Color(0x4DFFDADB), // approx 0.3 opacity
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.black.withOpacity(0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(appIcons.lotas, height: 16, width: 16, color: appColors.primary),
                              const SizedBox(width: 6),
                              CommonText(
                                "Onboarding Journey",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1D1B1A),
                                  letterSpacing: 0.24,
                                ),
                              ),
                            ],
                          ),
                          CommonText(
                            "4 of 5 Completed",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF576245),
                              letterSpacing: 0.33,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EDEB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.8, // 4 of 5
                          child: Container(
                            decoration: BoxDecoration(
                              color: appColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CommonText(
                  "Begin with Chapter 01 to anchor your personalized care team match.",
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF6D615C),
                    height: 18 / 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final String chapterNumber;
  final String title;
  final String subtitle;
  final String status;
  final bool isComplete;
  final String icon;
  final Color iconBgColor;
  final Color? iconColor;
  final String buttonText;
  final bool isPrimaryAction;
  final VoidCallback onTapButton;

  const _ChapterCard({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.isComplete,
    required this.icon,
    required this.iconBgColor,
    this.iconColor,
    required this.buttonText,
    required this.isPrimaryAction,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              color: iconColor ?? const Color(0xFF292726),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonText(
                      chapterNumber,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: appColors.primary,
                        letterSpacing: 0.55,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(isComplete ? appIcons.complete : appIcons.pending, height: 14, width: 14, color: Color(0xFF5B6749)),
                    const SizedBox(width: 4),
                    CommonText(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isComplete
                            ? const Color(0xFF5B6749)
                            : const Color(0xFF857373),
                        letterSpacing: 0.33,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CommonText(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Playfair_Display",
                    color: const Color(0xFF292726),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                CommonText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF6D615C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onTapButton,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPrimaryAction ? appColors.primary : appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText(
                buttonText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPrimaryAction ? appColors.white : appColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
