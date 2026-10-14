import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class ProfileChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedBgColor;
  final Color? selectedTextColor;

  const ProfileChip({
    super.key, required this.label, required this.isSelected, required this.onTap,
    this.selectedBgColor, this.selectedTextColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (selectedBgColor ?? const Color(0xFFFFDADB)) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? (selectedTextColor ?? const Color(0xFF3A0910)) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
