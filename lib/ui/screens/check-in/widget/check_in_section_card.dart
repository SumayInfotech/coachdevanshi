import 'package:flutter/material.dart';
import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class CheckInSectionCard extends StatelessWidget {
  final String title;
  final String? icon;
  final Color? iconBgColor;
  final Color? iconColor;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const CheckInSectionCard({
    super.key,
    required this.title,
    this.icon,
    this.iconBgColor,
    this.iconColor,
    required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
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
            children: [
              if (iconBgColor != null && icon != null)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(icon!, height: 16, width: 16, color: iconColor),
                )
              else if (icon != null)
                Image.asset(icon!, height: 20, width: 20, color: iconColor),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  title,
                  fontFamily: fontPlayfairDisplay,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1B1A),
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
