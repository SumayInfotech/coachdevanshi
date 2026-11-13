import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/blocs/home/dashboard/dashboard_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/models/home/dashboard_model.dart';
import '../../../core/services/loader_service.dart';
import '../../../main.dart';
import '../bottom_bar_screen.dart';
import '../coach/fat_loss_inch_loss_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/blood_report_upload_screen.dart';
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
  DashboardModel? dashboardModel;

  @override
  void initState() {
    super.initState();
    callDashboardAPI();
  }

  void callDashboardAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<DashboardBloc>(context).add(
        const UserDashboardEvent(url: Urls.dashboard),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardSuccess) {
          LoaderService.hide();
          setState(() {
            dashboardModel = state.model;
          });
        } else if (state is DashboardFailed) {
          LoaderService.hide();
          appLog(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Header Bar
              HomeHeaderBar(
                hasUnreadNotifications: (dashboardModel?.data?.unreadNotifications ?? 0) > 0,
                onProfileTap: () => appLog("Profile tapped"),
                onNotificationTap: () => navigation.push(context, const NotificationsScreen()),
              ),
              // Main Content Area
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<DashboardBloc>(context).add(
                      const UserDashboardEvent(url: Urls.dashboard),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final data = dashboardModel?.data;
    final plan = data?.plan;
    final today = data?.todayOverview;
    final checkins = data?.checkins;

    final String? greetingText = (data != null && data.name != null && data.name!.isNotEmpty)
        ? "${data.greeting ?? "Good morning"}, ${data.name}"
        : null;

    final String stepCount = today?.steps != null ? today!.steps.toString() : "--";
    final String weightText = today?.weight != null ? "${today!.weight?.current} kg" : "--";

    final String? microBadgeText = checkins?.micro?.status != null
        ? (checkins!.micro!.status![0].toUpperCase() + checkins.micro!.status!.substring(1))
        : null;
    final String? weeklyBadgeText = checkins?.weekly?.status != null
        ? (checkins!.weekly!.status![0].toUpperCase() + checkins.weekly!.status!.substring(1))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restorative Quote / Botanical Nudge (hidden if quote is null or empty)
        if (data?.quote != null && data!.quote!.trim().isNotEmpty) ...[
          RestorativeQuoteCard(quote: "“${data.quote!.trim()}”"),
          const SizedBox(height: 16),
        ],

        // Greeting & Profile Banner
        GreetingBanner(
          dateText: data?.dateLabel,
          greetingText: greetingText,
        ),
        const SizedBox(height: 18),

        // Your Plan Card (hidden if plan is null)
        if (plan != null) ...[
          YourPlanCard(
            planTag: "YOUR PLAN",
            planTitle: plan.title ?? "",
            durationSubtitle: "${plan.daysLeft ?? 0} days left • Ends on ${plan.endDateLabel ?? ""}",
            progressPercent: ((plan.progressPercent ?? 0) / 100.0).clamp(0.0, 1.0),
            showPhaseStatus: plan.pathway?.title != null && plan.pathway!.title!.isNotEmpty,
            phaseTitle: plan.pathway?.title ?? "",
            statusText: plan.status ?? "Active",
            onTap: () => navigation.push(context, const FatLossInchLossScreen()),
          ),
          const SizedBox(height: 16),
        ],

        // Note from Coach Card (hidden if coach note is null or empty)
        if (data?.coachNote != null && data!.coachNote!.note!.trim().isNotEmpty) ...[
          NoteFromCoachCard(
            note: "“${data.coachNote!.note!.trim()}”",
            onTap: () => appLog("Note from coach tapped"),
          ),
          const SizedBox(height: 16),
        ],

        // Today's Overview Grid (hidden if today overview & checkins are null)
        if (today != null || checkins != null) ...[
          TodayOverviewGrid(
            stepCount: stepCount,
            weightText: weightText,
            microBadgeText: microBadgeText,
            weeklyBadgeText: weeklyBadgeText,
            isMicroDone: checkins?.micro?.isDone,
            updatedTime: today?.stepsSyncedAt,
            onStepsTap: () => appLog("Daily steps card tapped"),
            onSyncTap: () => appLog("Sync steps tapped"),
            onWeightTap: () => appLog("Weight card tapped"),
            onAddWeightTap: () => appLog("Add weight tapped"),
            onMicroCheckinTap: () => bottomPageController.jumpToPage(BottomBarScreenIndex.checkIn),
            onWeeklyCheckinTap: () => bottomPageController.jumpToPage(BottomBarScreenIndex.progress),
          ),
          const SizedBox(height: 16),
        ],

        // Today's Actions (hidden if checkins is null)
        if (checkins != null) ...[
          TodayActionsRow(
            onLogMicroCheckIn: () => bottomPageController.jumpToPage(BottomBarScreenIndex.checkIn),
            onFillWeeklyCheckIn: () => bottomPageController.jumpToPage(BottomBarScreenIndex.progress),
          ),
          const SizedBox(height: 20),
        ],

        // Quick Access Grid (Food Diary, Progress Photos, Upload Reports)
        QuickAccessGrid(
          onFoodDiaryTap: () => navigation.push(context, const ThreeDayFoodDiaryScreen()),
          onProgressPhotosTap: () => navigation.push(context,
            const TrackWeeklyProgressScreen(isBack: true),
          ),
          onUploadReportsTap: () => navigation.push(context,
            const BloodReportUploadScreen(isBack: true),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
