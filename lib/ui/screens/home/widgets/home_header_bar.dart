import 'package:flutter/material.dart';

import '../../../../main.dart';

class HomeHeaderBar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool hasUnreadNotifications;

  const HomeHeaderBar({
    super.key,
    this.onProfileTap,
    this.onNotificationTap,
    this.hasUnreadNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8F2F0),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  appImages.userAvatarPlaceholder,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person_rounded,
                      color: appColors.primary,
                      size: 22,
                    );
                  },
                ),
              ),
            ),
          ),
          // Title
          const Text(
            "Home",
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D1B1A),
            ),
          ),
          // Notification Icon
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF8F2F0),
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.homeNotificationBell,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF1D1B1A),
                          size: 20,
                        );
                      },
                    ),
                  ),
                ),
                if (hasUnreadNotifications)
                  Positioned(
                    right: 7,
                    top: 7,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.primary,
                        border: Border.all(
                          color: appColors.bgColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
