import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<Widget> children;

  const ProfileSectionCard({super.key, required this.title, required this.icon, required this.children});

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
                padding: const EdgeInsets.only(top: 7),
                child: Image.asset(icon, height: 20, width: 20, color: appColors.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Playfair_Display",
                    color: const Color(0xFF1D1B1A),
                    letterSpacing: 0
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
