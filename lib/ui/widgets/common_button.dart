import 'package:flutter/material.dart';

import '../../core/constants/utils.dart';
import '../../main.dart';
import 'common_text.dart';

class CommonButton extends StatefulWidget {
  final String? name;
  final String? image;
  final bool isIconFirst;
  final TextAlign? textAlign;
  final double? imageSize;
  final double? width;
  final Color? btnColor;
  final Color? borderColor;
  final IconData? icon;
  final List<Color>? colors;
  final Color? fontColor;
  final double? radius;
  final MainAxisAlignment? mainAxisAlignment;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final VoidCallback onTap;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CommonButton({
    super.key,
    this.name,
    required this.onTap,
    this.width, this.height, this.textAlign, this.fontSize, this.btnColor, this.borderColor,
    this.fontColor, this.image, this.imageSize, this.fontWeight, this.icon, this.radius, this.mainAxisAlignment, this.colors, this.boxShadow, this.isIconFirst = true,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> with SingleTickerProviderStateMixin {

  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) async {
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 100));
    // ignore: use_build_context_synchronously
    FocusScope.of(context).unfocus();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: appColors.transparent,
      overlayColor: WidgetStatePropertyAll(appColors.transparent),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          height: widget.height ?? 48,
          decoration: BoxDecoration(
            color: widget.btnColor ?? appColors.primary,
            // gradient: widget.btnColor == null ? LinearGradient(
            //   colors: widget.colors ?? [
            //     appColors.btnGradient1,
            //     appColors.btnGradient2,
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ) : null,
            border: Border.all(color: widget.borderColor ?? appColors.transparent),
            borderRadius: BorderRadius.circular(widget.radius ?? 999),
            boxShadow: widget.boxShadow ?? [],
          ),
          child: Center(
            child: Row(
              spacing: 10,
              mainAxisAlignment: widget.mainAxisAlignment ?? (widget.image != null ? MainAxisAlignment.center : MainAxisAlignment.center),
              children: [
                if (widget.image != null && widget.isIconFirst == true)
                  Image.asset(widget.image ?? "", height: widget.imageSize ?? 20),
                if (widget.icon != null && widget.isIconFirst == true)
                  Icon(widget.icon, size: widget.imageSize ?? 20, color: widget.fontColor ?? appColors.white),
                CommonText(
                  (widget.name ?? "Continue").capitalizeEachWord(),
                  textAlign: widget.textAlign,
                  style: TextStyle(
                    color: widget.fontColor ?? appColors.white,
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: widget.fontWeight ?? FontWeight.w600,
                    fontStyle: .normal,
                  ),
                ),
                if (widget.image != null && widget.isIconFirst == false)
                  Image.asset(widget.image ?? "", height: widget.imageSize ?? 20),
                if (widget.icon != null && widget.isIconFirst == false)
                  Icon(widget.icon, size: widget.imageSize ?? 20, color: widget.fontColor ?? appColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
