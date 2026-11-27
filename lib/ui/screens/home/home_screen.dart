import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/blocs/coach/pathways/pathways_bloc.dart';
import '../../../core/blocs/coach/pathways/pathways_event.dart';
import '../../../core/blocs/coach/pathways/pathways_state.dart';
import '../../../core/blocs/home/dashboard/dashboard_bloc.dart';
import '../../../core/blocs/home/health_sync/health_sync_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/pathways_model.dart';
import '../../../core/models/home/dashboard_model.dart';
import '../../../core/services/health_service.dart';
import '../../../core/services/loader_service.dart';
import '../../../main.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import '../chat/chat_screen.dart';
import '../coach/fat_loss_inch_loss_screen.dart';
import '../coach/gut_reset_protocol_screen.dart';
import '../coach/healthy_weight_gain_screen.dart';
import '../coach/maintenance_lifestyle_screen.dart';
import '../coach/reproductive_life_stage_screen.dart';
import '../coach/rooted_recovery_screen.dart';
import '../coach/select_pathway_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/blood_report_upload_screen.dart';
import '../profile/update_profile_screen.dart';
import '../progress/three_day_food_diary_screen.dart';
import '../progress/track_weekly_progress_screen.dart';
import 'widgets/greeting_banner.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/home_shimmer_loading.dart';
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
  PathwaysModel? _pathwaysModel;

  @override
  void initState() {
    super.initState();
    callDashboardAPI();
    callGetPathwaysAPI();
  }

  void callDashboardAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<DashboardBloc>(context).add(
        const UserDashboardEvent(url: Urls.dashboard),
      );
    });
  }

  void callGetPathwaysAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = BlocProvider.of<PathwaysBloc>(context).state;
      if (state is PathwaysSuccess) {
        _pathwaysModel = state.model;
      } else {
        BlocProvider.of<PathwaysBloc>(context).add(
          const UserGetPathwaysEvent(url: Urls.pathways),
        );
      }
    });
  }

  PathwayItem? _findPathwayItem(PathwaysModel? pathwaysModel, String targetUuid, String targetTitle) {
    if (pathwaysModel?.data?.groups == null) return null;

    final lowerTitle = targetTitle.toLowerCase().trim();

    // 1. Search dynamically across all groups from API response by UUID
    if (targetUuid.isNotEmpty) {
      for (final group in pathwaysModel!.data!.groups!) {
        final pathways = group.pathways ?? [];
        for (final item in pathways) {
          if (item.uuid != null && item.uuid!.trim().toLowerCase() == targetUuid.toLowerCase()) {
            return item;
          }
        }
      }
    }

    // 2. If not matched by UUID, search by title or slug from API response
    if (lowerTitle.isNotEmpty) {
      for (final group in pathwaysModel!.data!.groups!) {
        final pathways = group.pathways ?? [];
        for (final item in pathways) {
          final itemTitle = (item.title ?? '').toLowerCase().trim();
          final itemSlug = (item.slug ?? '').toLowerCase().trim();
          if (itemTitle == lowerTitle ||
              itemSlug == lowerTitle ||
              (itemTitle.isNotEmpty && lowerTitle.contains(itemTitle)) ||
              (itemTitle.isNotEmpty && itemTitle.contains(lowerTitle))) {
            return item;
          }
        }
      }
    }

    return null;
  }

  Widget _resolveScreenForPathway({
    required PathwayItem? item,
    required String fallbackUuid,
    required String fallbackTitle,
  }) {
    final String uuid = (item?.uuid ?? fallbackUuid).trim();
    final String slug = (item?.slug ?? '').toLowerCase().trim();
    final String title = (item?.title ?? fallbackTitle).toLowerCase().trim();

    // Dynamically route based on matched pathway slug / title from API
    if (slug == "gut-reset" || title.contains("gut reset")) {
      return GutResetProtocolScreen(pathwayUuid: uuid);
    } else if (slug == "fat-loss-inch-loss" || title.contains("fat loss") || title.contains("inch loss")) {
      return FatLossInchLossScreen(pathwayUuid: uuid);
    } else if (slug == "healthy-weight-gain" || title.contains("weight gain")) {
      return HealthyWeightGainScreen(pathwayUuid: uuid);
    } else if (slug == "rooted-recovery-new-moms" || title.contains("rooted recovery") || title.contains("new moms")) {
      return RootedRecoveryScreen(pathwayUuid: uuid);
    } else if (slug == "maintenance-lifestyle" || title.contains("maintenance")) {
      return MaintenanceLifestyleScreen(pathwayUuid: uuid);
    } else if (slug == "reproductive-life-stage" || title.contains("reproductive")) {
      return ReproductiveLifeStageScreen(pathwayUuid: uuid);
    }

    // If pathway has no protocol or is not applicable
    if (slug == "not-applicable" || (item != null && item.hasProtocol == false)) {
      return const SelectPathwayScreen();
    }

    if (uuid.isEmpty && title.isEmpty) {
      return const SelectPathwayScreen();
    }

    return const SelectPathwayScreen();
  }

  Future<void> _navigateToPathway(PlanPathway? pathway) async {
    final String targetUuid = (pathway?.uuid ?? "").trim();
    final String targetTitle = (pathway?.title ?? pathway?.value ?? "").trim();

    if (targetUuid.isEmpty && targetTitle.isEmpty) {
      navigation.pushSlideAnimation(
        context,
        const SelectPathwayScreen(),
        onValue: (_) => callDashboardAPI(),
      );
      return;
    }

    PathwaysModel? model = _pathwaysModel;

    // If pathways haven't loaded yet, check current Bloc state or fetch dynamically
    if (model == null) {
      final pathwaysBloc = BlocProvider.of<PathwaysBloc>(context);
      if (pathwaysBloc.state is PathwaysSuccess) {
        model = (pathwaysBloc.state as PathwaysSuccess).model;
        _pathwaysModel = model;
      } else {
        LoaderService.show(context);
        pathwaysBloc.add(const UserGetPathwaysEvent(url: Urls.pathways));
        try {
          final nextState = await pathwaysBloc.stream
              .firstWhere((s) => s is PathwaysSuccess || s is PathwaysFailed)
              .timeout(const Duration(seconds: 10));
          if (nextState is PathwaysSuccess) {
            model = nextState.model;
            _pathwaysModel = model;
          }
        } catch (_) {}
        LoaderService.hide();
      }
    }

    // Find pathway dynamically from API response by matching UUID
    final matchedItem = _findPathwayItem(model, targetUuid, targetTitle);
    final targetScreen = _resolveScreenForPathway(
      item: matchedItem,
      fallbackUuid: targetUuid,
      fallbackTitle: targetTitle,
    );

    if (!mounted) return;
    navigation.pushSlideAnimation(
      context,
      targetScreen,
      onValue: (_) => callDashboardAPI(),
    );
  }

  Future<void> _handleHealthSync() async {
    LoaderService.show(context);
    final payload = await HealthService.getTodayHealthSyncPayload();
    if (!mounted) return;

    if (payload == null) {
      LoaderService.hide();
      showSnackBar(
        context: context,
        isError: true,
        message: "Unable to read health data. Please grant permissions in ${Platform.isAndroid ? 'Health Connect' : 'Apple Health'}.",
      );
      return;
    }

    BlocProvider.of<HealthSyncBloc>(context).add(
      UserHealthSyncEvent(
        url: Urls.healthSync,
        body: payload,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is DashboardSuccess) {
              LoaderService.hide();
              setState(() {
                dashboardModel = state.model;
              });
            } else if (state is DashboardFailed) {
              LoaderService.hide();
              appLog(state.message);
              if (dashboardModel == null) {
                showSnackBar(
                  context: context,
                  isError: true,
                  message: state.message.isNotEmpty ? state.message : "Failed to load dashboard data.",
                );
              }
            }
          },
        ),
        BlocListener<HealthSyncBloc, HealthSyncState>(
          listener: (context, state) {
            if (state is HealthSyncSuccess) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: false,
                message: state.model.message ?? "Health data synced successfully!",
              );
              // Refresh dashboard after successful sync
              callDashboardAPI();
            } else if (state is HealthSyncFailed) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: true,
                message: state.message,
              );
            }
          },
        ),
        BlocListener<PathwaysBloc, PathwaysState>(
          listener: (context, state) {
            if (state is PathwaysSuccess) {
              _pathwaysModel = state.model;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Header Bar
              HomeHeaderBar(
                hasUnreadNotifications: (dashboardModel?.data?.unreadNotifications ?? 0) > 0,
                onProfileTap: () => navigation.pushSlideAnimation(context, const UpdateProfileScreen()),
                onNotificationTap: () => navigation.push(context, const NotificationsScreen()),
              ),
              // Main Content Area
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<DashboardBloc>(context).add(
                      const UserDashboardEvent(url: Urls.dashboard),
                    );
                    BlocProvider.of<PathwaysBloc>(context).add(
                      const UserGetPathwaysEvent(url: Urls.pathways),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (context, state) {
                        if (state is DashboardLoading || (dashboardModel == null && state is! DashboardFailed)) {
                          return const HomeShimmerLoading();
                        } else if (state is DashboardFailed && dashboardModel == null) {
                          return _buildErrorState(state.message);
                        }
                        return _buildContent();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: appColors.primary,
            ),
            const SizedBox(height: 16),
            CommonText(
              message.isNotEmpty ? message : "Failed to load dashboard data",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: appColors.neutral,
              ),
            ),
            const SizedBox(height: 20),
            CommonButton(
              name: "Retry",
              width: 120,
              height: 42,
              btnColor: appColors.primary,
              fontColor: appColors.white,
              onTap: callDashboardAPI,
            ),
          ],
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
    final String weightText = today?.weight != null ? "${today!.weight?.current} ${today.weight?.unit ?? 'kg'}" : "--";

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
            showPhaseStatus: (plan.pathway?.title != null && plan.pathway!.title!.isNotEmpty) ||
                (plan.pathway?.value != null && plan.pathway!.value!.isNotEmpty),
            phaseTitle: plan.pathway?.title ?? plan.pathway?.value ?? "",
            statusText: plan.status ?? "Active",
            onTap: () => _navigateToPathway(plan.pathway),
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
            onSyncTap: _handleHealthSync,
            onWeightTap: () => appLog("Weight card tapped"),
            onAddWeightTap: () => bottomPageController.jumpToPage(BottomBarScreenIndex.progress),
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
          onFoodDiaryTap: () => navigation.push(context,
            const ThreeDayFoodDiaryScreen()
          ),
          onProgressPhotosTap: () => navigation.push(context,
            const TrackWeeklyProgressScreen(isBack: true),
          ),
          onUploadReportsTap: () => navigation.push(context,
            const BloodReportUploadScreen(isBack: true),
          ),
          onChatTap: () => navigation.pushSlideAnimation(context,
            const ChatScreen(),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
