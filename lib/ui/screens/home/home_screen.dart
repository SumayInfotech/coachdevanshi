import 'package:flutter/material.dart';

import '../../../main.dart';
import '../bottom_bar_screen.dart';
import '../coach/fat_loss_inch_loss_screen.dart';
import '../notifications/notifications_screen.dart';
import '../progress/three_day_food_diary_screen.dart';
import '../progress/track_weekly_progress_screen.dart';
import 'widgets/greeting_banner.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/note_from_coach_card.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/restorative_quote_card.dart';
import 'widgets/today_actions_row.dart';
import 'widgets/today_overview_grid.dart';
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
              onNotificationTap: () => navigation.push(context, const NotificationsScreen()),
            ),
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restorative Quote / Botanical Nudge (Placed at top as in new design)
                    const RestorativeQuoteCard(),
                    const SizedBox(height: 16),
                    // Greeting & Profile Banner
                    const GreetingBanner(),
                    const SizedBox(height: 18),
                    // Your Plan Card
                    YourPlanCard(
                      planTag: "YOUR PLAN",
                      planTitle: "Fat Loss & Inch\nLoss",
                      durationSubtitle: "120 days left • Ends on 30 Dec 2024",
                      progressPercent: 0.60,
                      showPhaseStatus: false,
                      onTap: () => navigation.push(context, const FatLossInchLossScreen()),
                    ),
                    const SizedBox(height: 16),
                    // Note from Coach Card
                    NoteFromCoachCard(
                      onTap: () => appLog("Note from coach tapped"),
                    ),
                    const SizedBox(height: 20),
                    // Today's Overview Grid (2x2: Steps & Weight, Micro & Weekly check-in)
                    TodayOverviewGrid(
                      stepCount: "7,842",
                      weightText: "64.5 kg",
                      onStepsTap: () => appLog("Daily steps card tapped"),
                      onSyncTap: () => appLog("Sync steps tapped"),
                      onWeightTap: () => appLog("Weight card tapped"),
                      onAddWeightTap: () => appLog("Add weight tapped"),
                      onMicroCheckinTap: () => bottomPageController.jumpToPage(BottomBarScreenIndex.checkIn),
                      onWeeklyCheckinTap: () => bottomPageController.jumpToPage(BottomBarScreenIndex.progress),
                    ),
                    const SizedBox(height: 16),
                    // Today's Actions (Dual Buttons)
                    TodayActionsRow(
                      onLogMicroCheckIn: () => bottomPageController.jumpToPage(BottomBarScreenIndex.checkIn),
                      onFillWeeklyCheckIn: () => bottomPageController.jumpToPage(BottomBarScreenIndex.progress),
                    ),
                    const SizedBox(height: 20),
                    // Quick Access Grid (Food Diary, Progress Photos, Upload Reports)
                    QuickAccessGrid(
                      onFoodDiaryTap: () => navigation.push(context, const ThreeDayFoodDiaryScreen()),
                      onProgressPhotosTap: () => navigation.push(context, const TrackWeeklyProgressScreen()),
                      onUploadReportsTap: () => appLog("Upload Reports tapped"),
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
