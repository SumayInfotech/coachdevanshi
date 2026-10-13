import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class TodayActionsRow extends StatelessWidget {
  final VoidCallback onLogMicroCheckIn;
  final VoidCallback onFillWeeklyCheckIn;

  const TodayActionsRow({
    super.key,
    required this.onLogMicroCheckIn,
    required this.onFillWeeklyCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button 1: Log Micro Check-in
        buildInkWell(
          onTap: onLogMicroCheckIn,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: appColors.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(appIcons.microCheckIn, width: 16, height: 16, color: Colors.white),
                SizedBox(width: 6),
                Flexible(
                  child: CommonText(
                    "Log Micro Check-in",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Button 2: Fill Weekly Check-in
        buildInkWell(
          onTap: onFillWeeklyCheckIn,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: appColors.neutral,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(appIcons.weeklyCheckIn, width: 16, height: 16, color: Color(0xFFF5EFED)),
                SizedBox(width: 6),
                Flexible(
                  child: CommonText(
                    "Fill Weekly Check-in",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF5EFED),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
