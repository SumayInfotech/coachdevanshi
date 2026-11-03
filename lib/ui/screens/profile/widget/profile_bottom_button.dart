import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_button.dart';

class ProfileBottomButton extends StatelessWidget {
  final String name;
  final double? fontSize;
  final VoidCallback onTap;

  const ProfileBottomButton({super.key, required this.onTap, required this.name, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding(context) > 0 ? bottomPadding(context) : 24
      ),
      decoration: BoxDecoration(
        color: appColors.bgColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292726).withValues(alpha: 0.04),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: CommonButton(
        name: name,
        icon: Icons.arrow_forward_rounded,
        isIconFirst: false,
        imageSize: 16,
        btnColor: appColors.primary,
        fontSize: fontSize ?? 12,
        fontWeight: FontWeight.w700,
        onTap: onTap,
      ),
    );
  }
}
