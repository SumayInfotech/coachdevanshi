import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          "Notifications",
          fontFamily: fontPlayfairDisplay,
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(bottom: bottomPadding(context)),
        children: [
          _NotificationCard(
            badgeText: "Due Today",
            badgeBgColor: const Color(0xFFFFDADB),
            badgeTextColor: const Color(0xFF8B484D),
            title: "Complete your Fat Loss and Inch Loss intake module",
            titleColor: const Color(0xFF8B484D),
            buttonText: "Fill Form Now",
            onTapButton: () {},
          ),
          const SizedBox(height: 16),
          _NotificationCard(
            badgeText: "Due This Sunday",
            badgeBgColor: const Color(0xFFD8E5BF),
            badgeTextColor: const Color(0xFF576245),
            title: "Submit your weekly progress data & measurements",
            titleColor: const Color(0xFF1D1B1A),
            buttonText: "Log Weekly Progress",
            onTapButton: () {},
          ),
          const SizedBox(height: 16),
          _NotificationCard(
            badgeText: "Day 3 of 7",
            badgeBgColor: const Color(0xFFD8E5BF),
            badgeTextColor: const Color(0xFF576245),
            title: "Log your daily steps, sleep, and water baseline",
            titleColor: const Color(0xFF1D1B1A),
            buttonText: "Log Daily Data",
            onTapButton: () {},
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String badgeText;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final String title;
  final Color titleColor;
  final String buttonText;
  final VoidCallback onTapButton;

  const _NotificationCard({
    required this.badgeText,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.title,
    required this.titleColor,
    required this.buttonText,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: CommonText(
              badgeText,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.24,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CommonText(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.675,
              height: 22 / 15,
            ),
          ),
          const SizedBox(height: 16),
          CommonButton(
            height: 34,
            btnColor: appColors.primary,
            onTap: onTapButton,
            name: buttonText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            icon: Icons.arrow_forward_rounded,
            imageSize: 16,
            isIconFirst: false,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
