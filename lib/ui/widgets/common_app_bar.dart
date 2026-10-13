import 'package:flutter/material.dart';

import '../../core/constants/utils.dart';
import '../../main.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLeading;
  final Widget? title;
  final Widget? leading;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final TextStyle? titleTextStyle;
  final Color? appBarColor;
  final PreferredSizeWidget? bottom;

  const CommonAppBar({
    super.key,
    this.centerTitle = false,
    this.title,
    this.actions,
    this.onBack,
    this.isLeading = true,
    this.appBarColor,
    this.leading,
    this.titleTextStyle,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor ?? appColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      centerTitle: centerTitle,
      title: title,
      bottom: bottom,
      titleTextStyle: titleTextStyle ??
        TextStyle(
          fontSize: 20,
          color: appColors.black,
          fontWeight: .bold,
          fontFamily: fontFamilyPlusJakartaSans,
        ),
      automaticallyImplyLeading: false,
      leading: isLeading
          ? leading ?? buildInkWell(
            onTap: onBack ?? () => navigation.pop(context),
            child: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F3FA),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.black,
              ),
            ),
          )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
