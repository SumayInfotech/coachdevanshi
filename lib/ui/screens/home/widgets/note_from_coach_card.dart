import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class NoteFromCoachCard extends StatelessWidget {
  final String note;
  final VoidCallback? onTap;

  const NoteFromCoachCard({
    super.key,
    this.note = "“Ananya, your digestive observations from Thursday reflect good gut ease with cooked warm lentils. Keep adhering to the 30-minute window for your morning water cadence before tea. Looking forward to our 1:1 check-in this Wednesday at 4:30 PM.”",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonText(
            "Note from coach",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1B1A),
            ),
            fontFamily: fontFamilyPlusJakartaSans,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CommonText(note,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Color(0xFF1D1B1A),
                height: 1.5,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ),
        ],
      ),
    );
  }
}
