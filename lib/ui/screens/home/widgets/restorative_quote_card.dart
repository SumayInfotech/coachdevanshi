import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class RestorativeQuoteCard extends StatelessWidget {
  final String quote;

  const RestorativeQuoteCard({
    super.key,
    this.quote = "“Small, grounded rituals build sustainable nourishment.”",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD8E5BF).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botanical icon badge
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD8E5BF),
            ),
            child: Center(
              child: Image.asset(
                appIcons.homeLeafNudge,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.spa_rounded,
                    color: Color(0xFF404A2F),
                    size: 18,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Quote Text
          Expanded(
            child: CommonText(
              quote,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF404A2F),
                height: 1.54,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ),
        ],
      ),
    );
  }
}
