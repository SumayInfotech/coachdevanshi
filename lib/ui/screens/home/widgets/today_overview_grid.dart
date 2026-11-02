import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class TodayOverviewGrid extends StatelessWidget {
  final String? updatedTime;
  final String stepCount;
  final String weightText;
  final VoidCallback? onStepsTap;
  final VoidCallback? onSyncTap;
  final VoidCallback? onWeightTap;
  final VoidCallback? onAddWeightTap;
  final VoidCallback? onMicroCheckinTap;
  final VoidCallback? onWeeklyCheckinTap;

  const TodayOverviewGrid({
    super.key,
    this.updatedTime,
    this.stepCount = "7,842",
    this.weightText = "64.5 kg",
    this.onStepsTap,
    this.onSyncTap,
    this.onWeightTap,
    this.onAddWeightTap,
    this.onMicroCheckinTap,
    this.onWeeklyCheckinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText(
              "Today's Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
              fontFamily: 'serif',
            ),
            if (updatedTime != null && updatedTime!.isNotEmpty)
              CommonText(
                updatedTime!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 1: Steps & Weight Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Card: Daily Steps
            Expanded(
              child: _buildMetricCard(
                subtitle: "Apple Health &\nGoogle Fit Active Sync",
                iconWidget: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD8E5BF).withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.homeStepsIcon,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.directions_walk_rounded,
                          color: Color(0xFF576245),
                          size: 20,
                        );
                      },
                    ),
                  ),
                ),
                value: stepCount,
                label: "Daily Steps",
                actionText: "Sync Now",
                onActionTap: onSyncTap,
                onTap: onStepsTap,
              ),
            ),
            const SizedBox(width: 12),
            // Right Card: Weight
            Expanded(
              child: _buildMetricCard(
                subtitle: "Weight lost or gained\nsince your last entry",
                iconWidget: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFDADB).withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.weight,
                      width: 18,
                      height: 18,
                      color: appColors.primary,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.scale_rounded,
                          color: appColors.primary,
                          size: 18,
                        );
                      },
                    ),
                  ),
                ),
                value: weightText,
                label: "Weight",
                actionText: "Add Now",
                onActionTap: onAddWeightTap,
                onTap: onWeightTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Micro Check-in & Weekly Check-in
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Micro Check-in
            Expanded(
              child: _buildCheckInCard(
                iconWidget: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.homeMicroCheckinIcon,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.assignment_turned_in_rounded,
                          color: appColors.primary,
                          size: 16,
                        );
                      },
                    ),
                  ),
                ),
                title: "Micro Check-in",
                subtitle: "Daily mood & meals",
                badgeText: "Due",
                badgeBgColor: const Color(0xFFFFDADB),
                badgeTextColor: const Color(0xFF713439),
                onTap: onMicroCheckinTap,
              ),
            ),
            const SizedBox(width: 12),
            // Right: Weekly Check-in
            Expanded(
              child: _buildCheckInCard(
                iconWidget: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF2EDEB),
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.homeWeeklyCheckinIcon,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.calendar_month_rounded,
                          color: Color(0xFF534343),
                          size: 16,
                        );
                      },
                    ),
                  ),
                ),
                title: "Weekly Check-in",
                subtitle: "Baseline & Progress",
                onTap: onWeeklyCheckinTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String subtitle,
    required Widget iconWidget,
    required String value,
    required String label,
    required String actionText,
    VoidCallback? onActionTap,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
              child: CommonText(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF534343),
                  height: 1.3,
                ),
                fontFamily: fontFamilyPlusJakartaSans,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                iconWidget,
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1B1A),
                          letterSpacing: -0.5,
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      CommonText(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF534343),
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: GestureDetector(
                onTap: onActionTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EDEB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CommonText(
                    actionText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF302826),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCard({
    required Widget iconWidget,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeBgColor,
    Color? badgeTextColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconWidget,
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBgColor ?? const Color(0xFFFFDADB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CommonText(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: badgeTextColor ?? const Color(0xFF713439),
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 10),
            CommonText(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            const SizedBox(height: 2),
            CommonText(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF534343),
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ],
        ),
      ),
    );
  }
}
