import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../ui/widgets/common_button.dart';
import '../../ui/widgets/common_text.dart';

/// ---------------------------------------------------
/// Common Static Variables
/// ---------------------------------------------------

const String appName = "Coach Devanshi Doshi";
const String fontFamilyPlusJakartaSans = "Plus_Jakarta_Sans";
const String fontPlayfairDisplay = "Playfair_Display";

ValueNotifier<bool> isSearchOpenNotifier = ValueNotifier(false);
ValueNotifier<String?> searchQueryNotifier = ValueNotifier(null);

const String noDataFound = "No Data Found";

const String connectionTimeout = "Connection Timeout";
const String badRequest = "Bad Request";
const String unauthorized = "Your Session Expired!";
const String notFound = "Not Found";
const String methodNotAllowed = "Method Not Allowed";
const String internalServerError = "Internal Server Error";
const String noInternetFound = "No Internet Found";
const String somethingWentWrong = "Something Went Wrong";

const String longDateFormat = "MMM dd, yyyy";
double bottomPadding(BuildContext context) => MediaQuery.paddingOf(context).bottom + 20;

/// Formatter that allows only digits and a single dot, with optional digits after the dot.
/// Valid examples: "1", "1.5", "10.20"
/// Invalid examples: "1.", "1.1.1", "1.222" (if restricted further), ".."
FilteringTextInputFormatter digitalWithDot = FilteringTextInputFormatter.allow(
  RegExp(r'^\d+\.?\d{0,2}'),
);

/// ---------------------------------------------------
/// Extension
/// ---------------------------------------------------
extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String capitalizeEachWord() {
    if (trim().isEmpty) return this;

    return split(' ')
        .map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}


/// ---------------------------------------------------
/// Data Types Function
/// ---------------------------------------------------
String formatDateString({required String? date, required String outputFormat, String inputFormat = "dd-MM-yyyy",}) {
  if (date == null || date.isEmpty) return "";
  try {
    final parsedDate = DateFormat(inputFormat).parse(date);
    return DateFormat(outputFormat).format(parsedDate);
  } catch (e) {
    return "";
  }
}

EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20);
double commonBottomSpace = 70;

bool isNumeric(String s) => RegExp(r'^[0-9]+$').hasMatch(s);

bool isEmailValidate(String em) {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

bool isUsernameValidate(String username) {
  final regExp = RegExp(r'^[a-zA-Z0-9._-]{2,}$');
  return regExp.hasMatch(username);
}

bool isProperNameValid(String name) {
  final regExp = RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$');
  return regExp.hasMatch(name.trim());
}

bool isMobileValidate(String em) {
  String p = r'^\d{10}$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

bool isPasswordValid(String password) {
  String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(password);
}

/// ---------------------------------------------------
/// Common Loader
/// ---------------------------------------------------
Widget commonLoader({Color? color}) {
  return Center(
    child: SizedBox(
      height: 40,
      width: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            backgroundColor: appColors.primary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(appColors.primary),
          ),
        ),
      ),
    ),
  );
}

/// ---------------------------------------------------
/// Common Error Text
/// ---------------------------------------------------
Widget errorTextWidget({
  String title = noDataFound,
  VoidCallback? tryAgain,
}) {
  final bool isNoInternet = title == noInternetFound;
  final bool isNoData = title == noDataFound;

  final String displayTitle = title.capitalizeEachWord();

  final IconData icon = isNoInternet
      ? Icons.wifi_off_rounded
      : isNoData
      ? Icons.inbox_outlined
      : Icons.error_outline_rounded;

  final String description = isNoInternet
      ? "Please check your internet connection and try again."
      : isNoData
      ? "There is nothing to display right now."
      : "Something went wrong. Please try again.";

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            displayTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade600,
            ),
          ),

          // Retry button
          if (tryAgain != null) ...[
            const SizedBox(height: 24),

            CommonButton(
              name: "Try Again",
              onTap: tryAgain,
              width: 140,
              height: 48,
            ),
          ],
        ],
      ),
    ),
  );
}
/*Widget errorTextWidget({String title = noDataFound, VoidCallback? tryAgain}) {
  switch(title){
    case noDataFound:
      return Center(child: Text(noDataFound.capitalizeEachWord(), style: TextStyle(fontWeight: FontWeight.w500)));
    case noInternetFound:
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(noInternetFound.capitalizeEachWord(), style: TextStyle(fontWeight: FontWeight.w500)),
          if(tryAgain != null)...[
            const SizedBox(height: 20),
            CommonButton(
              name: "Try Again".capitalizeEachWord(), onTap: () => tryAgain.call(), width: 140, height: 50,
            ),
          ]
        ],
      ));
    default:
      return Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)));
  }
}*/

/// ---------------------------------------------------
/// Common Snackbar
/// ---------------------------------------------------
void showSnackBar({
  required BuildContext context,
  required bool isError,
  required String message,
  double? fontSize,
}) {
  final bg = isError ? appColors.red : appColors.primary;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: appColors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonText(
                message.capitalizeEachWord(),
                style: TextStyle(
                  fontSize: fontSize ?? AppTextSize.s12,
                  fontWeight: FontWeight.w500,
                  color: appColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

Future<T?> showCommonBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = false,
  bool enableDrag = false,
  bool showDragHandle = false,
  double? heights,
  Color backgroundColor = Colors.white,
  VoidCallback? onWhenComplete,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    useSafeArea: true,
    useRootNavigator: true,
    constraints: BoxConstraints(maxHeight: heights ?? (height * 0.9)),
    backgroundColor: backgroundColor,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (modalContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      );
    },
  ).whenComplete(() {
    onWhenComplete?.call();
  });
}

/// ---------------------------------------------------
/// Common Ink Well
/// ---------------------------------------------------
InkWell buildInkWell({
  required Widget child,
  required VoidCallback onTap,
  BorderRadius? borderRadius,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: borderRadius,
    splashColor: appColors.transparent,
    focusColor: appColors.transparent,
    highlightColor: appColors.transparent,
    hoverColor: appColors.transparent,
    overlayColor: WidgetStatePropertyAll(appColors.transparent),
    child: child,
  );
}

class AppPlatform {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
}

class AppTextSize {
  static double s12 = 12;
  static double s13 = 13;
  static double s14 = 14;
  static double s15 = 15;
  static double s16 = 16;
  static double s17 = 17;
  static double s18 = 18;
  static double s19 = 19;
  static double s20 = 20;
  static double s21 = 21;
  static double s22 = 22;
  static double s23 = 23;
  static double s24 = 24;
  static double s25 = 25;
  static double s26 = 26;
  static double s27 = 27;
  static double s28 = 28;
  static double s29 = 29;
  static double s30 = 30;
  static double s31 = 31;
  static double s32 = 32;
  static double s33 = 33;
  static double s34 = 34;
}

Future<dynamic> commonDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  String confirmBtnText = "Yes",
  required VoidCallback onPressed,
  String cancelBtnText = "Cancel",
  VoidCallback? onCancel,
  Color? iconColor,
  String? image,
  IconData? icon,
  Color? confirmBtnColor,
  Color? confirmTextColor,
  Color? iconBgColor,
  bool isDanger = false,
}) {
  final effectiveIconColor = iconColor ?? (isDanger ? appColors.red : appColors.primary);
  final effectiveIconBgColor = iconBgColor ?? effectiveIconColor.withValues(alpha: 0.1);
  final effectiveConfirmColor = confirmBtnColor ?? (isDanger ? appColors.red : (iconColor ?? appColors.primary));

  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: appColors.neutral.withValues(alpha: 0.45),
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: ((scale - 0.85) / 0.15).clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Dialog(
              backgroundColor: appColors.white,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                // side: BorderSide(color: appColors.borderLight, width: 1.5),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.neutral.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Icon Badge
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: effectiveIconBgColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: effectiveIconColor.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: image != null ? Image.asset(
                        image,
                        color: effectiveIconColor,
                        fit: BoxFit.contain,
                      ) : icon != null ? Icon(
                        icon,
                        color: effectiveIconColor,
                      ) : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 15),

                    /// Title
                    CommonText(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTextSize.s18,
                        fontWeight: FontWeight.w700,
                        color: appColors.neutral,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Subtitle
                    CommonText(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTextSize.s14,
                        fontWeight: FontWeight.w400,
                        // color: appColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            name: cancelBtnText,
                            fontSize: AppTextSize.s14,
                            fontWeight: FontWeight.w600,
                            btnColor: appColors.white,
                            // borderColor: appColors.borderOutline,
                            fontColor: appColors.neutral,
                            height: 48,
                            radius: 14,
                            onTap: () {
                              navigation.pop(context);
                              onCancel?.call();
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: CommonButton(
                            name: confirmBtnText,
                            fontSize: AppTextSize.s14,
                            fontWeight: FontWeight.w600,
                            btnColor: effectiveConfirmColor,
                            fontColor: confirmTextColor ?? appColors.white,
                            height: 48,
                            radius: 14,
                            boxShadow: [
                              BoxShadow(
                                color: effectiveConfirmColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            onTap: () {
                              navigation.pop(context);
                              onPressed.call();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showImageDialog(String imagePath, BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Image Preview",
    barrierColor: Colors.black.withValues(alpha: 0.75),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: MediaQuery.of(context).size.height * .80,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Image.network(
                          imagePath,
                          width: width,
                          height: 250,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 250,
                              child: Center(
                                child: commonLoader(),
                              ),
                            );
                          },
                          errorBuilder: (_, _, _) {
                            return SizedBox(
                              height: 250,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.broken_image_rounded,
                                      color: appColors.red,
                                      size: 60,
                                    ),
                                    const SizedBox(height: 12),
                                    CommonText(
                                      "Unable to load image",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -14,
                    right: -14,
                    child: Material(
                      color: appColors.white,
                      shape: const CircleBorder(),
                      elevation: 8,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => navigation.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appColors.white,
                            border: Border.all(
                              // color: appColors.borderOutline,
                            ),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: appColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
      );
    },
  );
}