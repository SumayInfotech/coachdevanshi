import 'package:coach_devanshi_doshi/core/constants/utils.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class CommonText extends StatelessWidget {
  final String name;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? style;
  final String? fontFamily;
  final TextOverflow? overflow;

  const CommonText(this.name, {
    super.key,
    this.maxLines,
    this.textAlign,
    this.style, this.overflow, this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.visible,
      softWrap: true,
      style: style?.copyWith(fontFamily: fontFamily ?? fontFamilyPlusJakartaSans),
    );
  }
}

Widget mandatoryText({
  required String text, bool isRequired = false, TextStyle? style,
  String? fontFamily
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 8),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: style ?? TextStyle(
              fontSize: 14,
              fontFamily: fontFamily ?? fontFamilyPlusJakartaSans,
              color: appColors.neutral,
              fontWeight: FontWeight.w700,
              fontStyle: .normal,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: " *",
              style: TextStyle(
                color: appColors.red,
                fontFamily: fontFamily ?? fontFamilyPlusJakartaSans,
              ),
            ),
        ],
      ),
    ),
  );
}
