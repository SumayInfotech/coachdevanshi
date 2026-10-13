import 'dart:ui';
import 'package:coach_devanshi_doshi/ui/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';

class ConnectActivityScreen extends StatefulWidget {
  final bool fromSignUp;
  const ConnectActivityScreen({
    super.key, this.fromSignUp = false,
  });

  @override
  State<ConnectActivityScreen> createState() => _ConnectActivityScreenState();
}

class _ConnectActivityScreenState extends State<ConnectActivityScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: CommonAppBar(
              appBarColor: appColors.bgColor.withValues(alpha: 0.85),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B1A)),
                onPressed: () => navigation.pop(context),
              ),
              title: const CommonText(
                "Activity Setup",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                ),
                fontFamily: 'serif',
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.04),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      activityHeaderSection(),
                      const SizedBox(height: 36),
                      // Connection options
                      activityConnectionCard(
                        title: "Connect with Apple Health",
                        iconPath: appIcons.appleHealth,
                        onTap: () {

                        },
                      ),
                      const SizedBox(height: 16),
                      activityConnectionCard(
                        title: "Connect with Google Fit",
                        iconPath: appIcons.googleFit,
                        onTap: () {

                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      // Bottom Connect Later action
                      connectLaterButton(
                        onTap: () {
                          if(widget.fromSignUp) {
                            navigation.pushAndRemoveUntilSlideAnimation(context, BottomBarScreen());
                          } else {
                            navigation.pop(context);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget activityHeaderSection(){
    return Column(
      children: [
        // Hero badge icon
        Center(
          child: Image.asset(
            appIcons.activityHeroBadge,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF3DEDB),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: appColors.primary,
                  size: 26,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        // Title
        const CommonText(
          "Connect Your Activity",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w500,
            color: Color(0xFF292726),
            letterSpacing: -0.65,
            height: 1.26,
          ),
          fontFamily: 'serif',
        ),
        const SizedBox(height: 12),
        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CommonText(
            "Sync your steps and activity, from Apple Health or Google Fit.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D615C),
              height: 1.38,
            ),
          ),
        ),
      ],
    );
  }

  Widget activityConnectionCard({
    required String title,
    required String iconPath,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF8F2F0),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.fitness_center_rounded,
                      color: appColors.primary,
                      size: 20,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Card Title
            Expanded(
              child: CommonText(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                  letterSpacing: 0.14,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF6D615C),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget connectLaterButton({VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonText(
              "Connect Later",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: appColors.primary,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 6),
            Image.asset(
              appIcons.connectLaterArrow,
              width: 12,
              height: 12,
              color: appColors.primary,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: appColors.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
