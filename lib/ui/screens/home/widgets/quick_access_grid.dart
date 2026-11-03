import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class QuickAccessItem {
  final String title;
  final String? iconPath;
  final Color iconBgColor;
  final IconData fallbackIcon;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickAccessItem({
    required this.title,
    this.iconPath,
    required this.iconBgColor,
    required this.fallbackIcon,
    required this.iconColor,
    this.onTap,
  });
}

class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem>? items;
  final bool showShortcuts;
  final VoidCallback? onShortcutsTap;
  final VoidCallback? onFoodDiaryTap;
  final VoidCallback? onProgressPhotosTap;
  final VoidCallback? onUploadReportsTap;

  const QuickAccessGrid({
    super.key,
    this.items,
    this.showShortcuts = false,
    this.onShortcutsTap,
    this.onFoodDiaryTap,
    this.onProgressPhotosTap,
    this.onUploadReportsTap,
  });

  @override
  Widget build(BuildContext context) {
    final list = items ?? [
      QuickAccessItem(
        title: "Food Diary",
        iconPath: appIcons.book,
        iconBgColor: const Color(0xFFFFDADB).withValues(alpha: 0.5),
        fallbackIcon: Icons.menu_book_rounded,
        iconColor: appColors.primary,
        onTap: onFoodDiaryTap,
      ),
      QuickAccessItem(
        title: "Progress Photos",
        iconPath: appIcons.addPhoto,
        iconBgColor: const Color(0xFFF2EDEB),
        fallbackIcon: Icons.camera_alt_outlined,
        iconColor: const Color(0xFF534343),
        onTap: onProgressPhotosTap,
      ),
      QuickAccessItem(
        title: "Upload Reports",
        iconBgColor: const Color(0xFFD8E5BF).withValues(alpha: 0.5),
        fallbackIcon: Icons.cloud_upload_outlined,
        iconColor: const Color(0xFF404A2F),
        onTap: onUploadReportsTap,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText("Quick Access",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
              fontFamily: 'serif',
            ),
            if (showShortcuts) GestureDetector(
              onTap: onShortcutsTap,
              child: CommonText("Shortcuts",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: appColors.primary,
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Shortcut Tiles Row
        Row(
          children: List.generate(list.length, (index) {
            final item = list[index];

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == list.length - 1 ? 0 : 10,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.iconBgColor,
                            ),
                            child: Center(
                              child: item.iconPath != null ? Image.asset(
                                item.iconPath!,
                                width: 20, height: 20,
                                color: item.iconColor,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    item.fallbackIcon,
                                    color: item.iconColor,
                                    size: 20,
                                  );
                                },
                              ) : Icon(
                                item.fallbackIcon,
                                color: item.iconColor,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CommonText(item.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
