import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/utils.dart';
import '../../../widgets/common_text.dart';
import '../../bottom_bar_screen.dart';

class GreetingBanner extends StatelessWidget {
  final String? dateText;
  final String? greetingText;

  const GreetingBanner({super.key, this.dateText, this.greetingText});

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
        if (greetingText != null && greetingText!.isNotEmpty)
          CommonText(
            greetingText!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1B1A),
              height: 1.4,
            ),
            fontFamily: 'serif',
          )
        else
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
