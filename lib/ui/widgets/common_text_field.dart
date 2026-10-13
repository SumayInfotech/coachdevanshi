import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/utils.dart';
import '../../main.dart';
import 'common_text.dart';

class CommonTextField extends StatelessWidget {
  final bool isBottomSpace;
  final String? hint;
  final String? error;
  final FocusNode? focusNode;
  final String? suffixText;
  final String label;
  final bool readOnly;
  final bool isRequired;
  final bool obscureText;
  final int? maxLines;
  final Color? borderColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? cursorColor;
  final TextStyle? style;
  final TextStyle? mandatoryStyle;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? filedWidth;
  final TextCapitalization textCapitalization;

  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const CommonTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.isRequired = true,
    this.obscureText = false,
    this.inputFormatters,
    this.filedWidth,
    this.autofillHints,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 1,
    this.error,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixText,
    this.contentPadding,
    this.style,
    this.mandatoryStyle,
    this.fillColor,
    this.isBottomSpace = false,
    this.hintColor,
    this.cursorColor,
    this.onFieldSubmitted, this.focusNode, this.borderColor,
  });

  @override
  Widget build(BuildContext context) {

    List<TextInputFormatter> formatters = inputFormatters == null
        ? [FilteringTextInputFormatter.deny(RegExp(r'^ '))]
        : inputFormatters! + [FilteringTextInputFormatter.deny(RegExp(r'^ '))];

    return SizedBox(
      width: kIsWeb ? filedWidth : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(label.isNotEmpty)...[
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: mandatoryText(
                text: label,
                isRequired: isRequired,
                style: mandatoryStyle,
              ),
            ),
          ],
          Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              readOnly: readOnly,
              obscureText: obscureText,
              autofillHints: autofillHints,
              keyboardType: keyboardType,
              inputFormatters: formatters,
              textInputAction: TextInputAction.done,
              maxLines: maxLines,
              textCapitalization: textCapitalization,
              style: style ?? TextStyle(color: appColors.black, fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: cursorColor ?? appColors.black,
              decoration: buildInputDecoration(
                hint: hint ?? "",
                hintColor: hintColor,
                borderColor: borderColor,
                style: style,
                cursorColor: cursorColor ?? appColors.black,
                error: error,
                fillColor: fillColor ?? (readOnly ? appColors.grey.withValues(alpha: 0.15) : appColors.textFieldBgColor),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                suffixText: suffixText,
                contentPadding: contentPadding,
              ),
              onTap: onTap,
              onChanged: onChanged,
              onSaved: (newValue) {},
              onFieldSubmitted: onFieldSubmitted,
            ),
          ),
          if (isBottomSpace) const SizedBox(height: 12),
        ],
      ),
    );
  }
}

InputDecoration buildInputDecoration({
  String? hint,
  String? error,
  String? suffixText,
  String? labelText,
  int? maxLines,
  Color? borderColor,
  Color? hintColor,
  Color? fillColor,
  Color? cursorColor,
  TextStyle? style,
  Widget? prefixIcon,
  Widget? suffixIcon,
  EdgeInsetsGeometry? contentPadding,
}) {
  final effectiveBorderColor = borderColor ?? appColors.textFieldBgColor.withValues(alpha: 0.2);
  final effectiveHintColor = hintColor ?? appColors.black.withValues(alpha: 0.4);

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: effectiveHintColor,
      fontSize: 14,
      fontFamily: fontFamilyPlusJakartaSans,
      fontWeight: FontWeight.w400,
    ),
    labelText: labelText,
    labelStyle: style ?? TextStyle(color: appColors.black, fontSize: 14),
    errorText: error,
    errorMaxLines: 3,
    contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    suffixText: suffixText,
    suffixStyle: TextStyle(
      color: hintColor ?? appColors.black.withValues(alpha: 0.6),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: fillColor ?? appColors.textFieldBgColor,
    enabledBorder: border(effectiveBorderColor),
    focusedBorder: focusedBorder(borderColor ?? appColors.black),
    errorBorder: errorBorder(),
    focusedErrorBorder: errorBorder(width: 1.8),
    disabledBorder: border(appColors.grey.withValues(alpha: 0.15)),
  );
}

OutlineInputBorder border(Color borderColor) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(
    width: 1,
    color: borderColor,
  ),
);

OutlineInputBorder focusedBorder(Color borderColor) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(
    width: 1.8,
    color: borderColor,
  ),
);

OutlineInputBorder errorBorder({double width = 1}) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(
    width: width,
    color: appColors.red,
  ),
);