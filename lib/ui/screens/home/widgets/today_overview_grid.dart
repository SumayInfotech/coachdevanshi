import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class TodayOverviewGrid extends StatelessWidget {
  final String updatedTime;
  final String stepCount;
  final String stepAvgComparison;
  final double stepProgress;
  final VoidCallback? onStepsTap;
  final VoidCallback? onMicroCheckinTap;
  final VoidCallback? onWeeklyCheckinTap;

  const TodayOverviewGrid({
    super.key,
    this.updatedTime = "Updated 10m ago",
    this.stepCount = "7,842",
    this.stepAvgComparison = "+12% vs avg",
    this.stepProgress = 0.78,
    this.onStepsTap,
    this.onMicroCheckinTap,
    this.onWeeklyCheckinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
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
            CommonText(
              updatedTime,
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
        // 2-Column Cards Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Card: Daily Steps
            Expanded(
              child: GestureDetector(
                onTap: onStepsTap,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(24),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8E5BF).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CommonText(
                              stepAvgComparison,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF576245),
                              ),
                              fontFamily: fontFamilyPlusJakartaSans,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CommonText(
                        stepCount,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1B1A),
                          letterSpacing: -0.5,
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        "Daily Steps",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF534343),
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                      ),
                      const SizedBox(height: 16),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: stepProgress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFF2EDEB),
                          valueColor: AlwaysStoppedAnimation<Color>(appColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right Column: Check-in Stack
            Expanded(
              child: Column(
                children: [
                  // Micro Check-in
                  GestureDetector(
                    onTap: onMicroCheckinTap,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(16),
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
                              Container(
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDADB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const CommonText(
                                  "Due today",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF713439),
                                  ),
                                  fontFamily: fontFamilyPlusJakartaSans,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const CommonText(
                            "Micro Check-in",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                          const SizedBox(height: 2),
                          const CommonText(
                            "Daily mood & meals",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF534343),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Weekly Check-in
                  GestureDetector(
                    onTap: onWeeklyCheckinTap,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(16),
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
                              Container(
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7E1DF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const CommonText(
                                  "Not due",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF534343),
                                  ),
                                  fontFamily: fontFamilyPlusJakartaSans,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const CommonText(
                            "Weekly Check-in",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                          const SizedBox(height: 2),
                          const CommonText(
                            "Sundays at 6:00 PM",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF534343),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
