import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class ProfileTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? error;
  final Function(String v)? onChanged;

  const ProfileTextArea({super.key, required this.controller, required this.hint, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
        border: error != null ? Border.all(color: appColors.red) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1D1B1A),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: const Color(0xFF9A8687), // Updated hint color to match design slightly better
                fontFamily: fontFamilyPlusJakartaSans,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: onChanged,
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CommonText(
                error ?? "",
                style: TextStyle(color: appColors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
