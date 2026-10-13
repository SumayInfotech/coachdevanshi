import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class QuickAccessItem {
  final String title;
  final String iconPath;
  final Color iconBgColor;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  const QuickAccessItem({
    required this.title,
    required this.iconPath,
    required this.iconBgColor,
    required this.fallbackIcon,
    this.onTap,
  });
}

class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem>? items;
  final VoidCallback? onCheckinTap;
  final VoidCallback? onNotesTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onMoreTap;

  const QuickAccessGrid({
    super.key,
    this.items,
    this.onCheckinTap,
    this.onNotesTap,
    this.onChatTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final list = items ??
        [
          QuickAccessItem(
            title: "Check-in",
            iconPath: appIcons.homeTileCheckin,
            iconBgColor: const Color(0xFFFFDADB).withValues(alpha: 0.5),
            fallbackIcon: Icons.assignment_turned_in_rounded,
            onTap: onCheckinTap,
          ),
          QuickAccessItem(
            title: "Notes",
            iconPath: appIcons.homeTileNotes,
            iconBgColor: const Color(0xFFF2EDEB),
            fallbackIcon: Icons.sticky_note_2_rounded,
            onTap: onNotesTap,
          ),
          QuickAccessItem(
            title: "Chat",
            iconPath: appIcons.homeTileChat,
            iconBgColor: const Color(0xFFD8E5BF).withValues(alpha: 0.5),
            fallbackIcon: Icons.chat_bubble_rounded,
            onTap: onChatTap,
          ),
          QuickAccessItem(
            title: "More",
            iconPath: appIcons.homeTileMore,
            iconBgColor: const Color(0xFFF2EDEB),
            fallbackIcon: Icons.grid_view_rounded,
            onTap: onMoreTap,
          ),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText(
              "Quick Access",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
              fontFamily: 'serif',
            ),
            CommonText(
              "Shortcuts",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: appColors.primary,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 4 Shortcut Tiles Row
        Row(
          children: List.generate(list.length, (index) {
            final item = list[index];

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == list.length - 1 ? 0 : 8,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.iconBgColor,
                            ),
                            child: Center(
                              child: Image.asset(
                                item.iconPath,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    item.fallbackIcon,
                                    color: appColors.primary,
                                    size: 18,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CommonText(
                            item.title,
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
