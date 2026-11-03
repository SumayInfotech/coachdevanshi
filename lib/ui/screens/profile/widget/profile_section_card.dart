import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final String? icon;
  final double? fontSize;
  final IconData? iconData;
  final List<Widget> children;

  const ProfileSectionCard({
    super.key,
    required this.title,
    this.icon,
    this.iconData,
    required this.children, this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: iconData != null ? Icon(
                  iconData, size: 20, color: appColors.primary
                ) : (icon != null ? Image.asset(
                  icon!,
                  height: 20,
                  width: 20,
                  color: appColors.primary,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.star_rounded, size: 20, color: appColors.primary
                  ),
                ) : const SizedBox.shrink()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(title,
                  fontFamily: fontPlayfairDisplay,
                  style: TextStyle(
                    fontSize: fontSize ?? 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
