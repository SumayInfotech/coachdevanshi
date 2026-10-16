import 'package:coach_devanshi_doshi/ui/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/utils.dart';
import '../../../widgets/common_text.dart';

class GreetingBanner extends StatelessWidget {
  final String? dateText;

  const GreetingBanner({super.key, this.dateText});

  @override
  Widget build(BuildContext context) {
    final String displayDate = dateText ?? DateFormat('EEEE, MMMM dd').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          displayDate.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF534343),
            letterSpacing: 0.55,
          ),
          fontFamily: fontFamilyPlusJakartaSans,
        ),
        const SizedBox(height: 2),
        ValueListenableBuilder(
          valueListenable: userData,
          builder: (context, user, _) {
            return CommonText(
              "Good morning, ${user?.name?.split(" ").first ?? ""}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
                height: 1.4,
              ),
              fontFamily: 'serif',
            );
          }
        ),
      ],
    );
  }
}
