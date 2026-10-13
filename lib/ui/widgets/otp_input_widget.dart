import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class OtpInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.length = 6,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hidden TextField
        Positioned.fill(
          child: Opacity(
            opacity: 0.0,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              showCursor: false,
              enableInteractiveSelection: false,
            ),
          ),
        ),
        // Visible OTP boxes
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(widget.focusNode);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (index) {
              return _buildOtpBox(index);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBox(int index) {
    final text = widget.controller.text;
    final isFocused = widget.focusNode.hasFocus && text.length == index;
    final hasValue = index < text.length;
    final value = hasValue ? text[index] : '';

    Color bgColor = appColors.textFieldBgColor; // #F8F2F0
    if (isFocused) {
      bgColor = const Color(0xFFFFDADB).withValues(alpha: 0.25);
    }

    return Container(
      width: 43.66,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: -2,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                )
              ],
      ),
      child: Center(
        child: hasValue
            ? Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Plus_Jakarta_Sans',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                  height: 1.18, // line-height ~38px
                  letterSpacing: -0.64,
                ),
              )
            : isFocused
                ? Container(
                    height: 24,
                    width: 2,
                    decoration: BoxDecoration(
                      color: appColors.primary,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  )
                : Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8C1C2).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
      ),
    );
  }
}
