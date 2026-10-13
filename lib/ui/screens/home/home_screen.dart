import 'package:flutter/material.dart';

import '../../../main.dart';
import '../notifications/notifications_screen.dart';
import 'widgets/greeting_banner.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/restorative_quote_card.dart';
import 'widgets/today_actions_row.dart';
import 'widgets/today_overview_grid.dart';
import 'widgets/weekly_rhythm_strip.dart';
import 'widgets/your_plan_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            HomeHeaderBar(
              onProfileTap: () => appLog("Profile tapped"),
              onNotificationTap: () => navigation.push(context, NotificationsScreen()),
            ),
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting & Profile Banner
                    const GreetingBanner(),
                    const SizedBox(height: 16),
                    // Restorative Quote / Botanical Nudge
                    const RestorativeQuoteCard(),
                    const SizedBox(height: 20),
                    // Your Plan Card
                    YourPlanCard(
                      onTap: () => appLog("Your Plan card tapped"),
                    ),
                    const SizedBox(height: 20),
                    // Today's Overview Grid
                    TodayOverviewGrid(
                      onStepsTap: () => appLog("Daily steps card tapped"),
                      onMicroCheckinTap: () => appLog("Micro check-in card tapped"),
                      onWeeklyCheckinTap: () => appLog("Weekly check-in card tapped"),
                    ),
                    const SizedBox(height: 16),
                    // Today's Actions (Dual Buttons)
                    TodayActionsRow(
                      onLogMicroCheckIn: () => appLog("Log Micro Check-in button tapped"),
                      onFillWeeklyCheckIn: () => appLog("Fill Weekly Check-in button tapped"),
                    ),
                    const SizedBox(height: 20),
                    // Calendar / Weekly Rhythm Strip
                    WeeklyRhythmStrip(
                      onDaySelected: (index) {
                        appLog("Selected day index: $index");
                      },
                    ),
                    const SizedBox(height: 20),
                    // Quick Access Grid
                    QuickAccessGrid(
                      onCheckinTap: () => appLog("Quick Access: Check-in"),
                      onNotesTap: () => appLog("Quick Access: Notes"),
                      onChatTap: () => appLog("Quick Access: Chat"),
                      onMoreTap: () => appLog("Quick Access: More"),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
