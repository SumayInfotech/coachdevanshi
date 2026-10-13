import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class YourPlanCard extends StatelessWidget {
  final String planTitle;
  final String durationSubtitle;
  final double progressPercent;
  final String phaseTitle;
  final String statusText;
  final VoidCallback? onTap;

  const YourPlanCard({
    super.key,
    this.planTitle = "6 Month Holistic\nJourney",
    this.durationSubtitle = "120 days left • Ends on 30 Dec 2026",
    this.progressPercent = 0.60,
    this.phaseTitle = "Phase 2: Gut Harmony & Vitality",
    this.statusText = "On Track",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
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
            children: [
              // Top Row: Title + Progress Ring
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          planTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1D1B1A),
                            height: 1.25,
                          ),
                          fontFamily: 'serif',
                        ),
                        const SizedBox(height: 6),
                        CommonText(
                          durationSubtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF534343),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Progress Ring
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: progressPercent,
                            strokeWidth: 5.5,
                            backgroundColor: const Color(0xFFEDE7E5),
                            valueColor: AlwaysStoppedAnimation<Color>(appColors.primary),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        CommonText(
                          "${(progressPercent * 100).toInt()}%",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D1B1A),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Soft milestone track bottom bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2F0).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(appIcons.checkShield, height: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonText(
                        phaseTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1D1B1A),
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: appColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonText(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: appColors.primary,
                          letterSpacing: 0.3,
                        ),
                        fontFamily: fontFamilyPlusJakartaSans,
                      ),
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
