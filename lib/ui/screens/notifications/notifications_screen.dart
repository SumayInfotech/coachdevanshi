import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/pathways/pathways_bloc.dart';
import '../../../core/blocs/coach/pathways/pathways_event.dart';
import '../../../core/blocs/coach/pathways/pathways_state.dart';
import '../../../core/blocs/home/dashboard/dashboard_bloc.dart';
import '../../../core/blocs/notifications/mark_read/mark_notification_read_bloc.dart';
import '../../../core/blocs/notifications/notifications_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/pathways_model.dart';
import '../../../core/models/notifications/notifications_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import '../coach/fat_loss_inch_loss_screen.dart';
import '../coach/gut_reset_protocol_screen.dart';
import '../coach/healthy_weight_gain_screen.dart';
import '../coach/maintenance_lifestyle_screen.dart';
import '../coach/reproductive_life_stage_screen.dart';
import '../coach/rooted_recovery_screen.dart';
import '../coach/select_pathway_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  PathwaysModel? _pathwaysModel;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    BlocProvider.of<NotificationsBloc>(context).add(
      const FetchNotificationsEvent(url: Urls.notifications),
    );
  }

  void _markNotificationAsRead(NotificationItem item) {
    final String uuid = (item.uuid ?? '').trim();
    if (uuid.isEmpty) return;

    if (item.isRead != true) {
      setState(() {
        item.isRead = true;
      });
    }

    BlocProvider.of<MarkNotificationReadBloc>(context).add(
      UserMarkNotificationReadEvent(
        url: Urls.markNotificationRead(notificationUuid: uuid),
        notificationUuid: uuid,
      ),
    );
  }

  void _onNotificationCardTapped(NotificationItem item) {
    _markNotificationAsRead(item);
    _handleNotificationAction(item);
  }

  void _handleNotificationAction(NotificationItem item) {
    final String action = (item.action ?? '').toLowerCase().trim();
    final String type = (item.type ?? '').toLowerCase().trim();

    if (action == "plan") {
      navigation.pop(context);
      _navigateToPathwayScreen(item);
    } else if (action == "home") {
      navigation.pop(context);
      bottomPageController.jumpToPage(BottomBarScreenIndex.home);
    } else if (action == "checkin" || action == "check_in" || action == "daily_checkin") {
      navigation.pop(context);
      bottomPageController.jumpToPage(BottomBarScreenIndex.checkIn);
    } else if (action == "progress" || action == "weekly_checkin") {
      navigation.pop(context);
      bottomPageController.jumpToPage(BottomBarScreenIndex.progress);
    } else if (action == "coach") {
      navigation.pop(context);
      bottomPageController.jumpToPage(BottomBarScreenIndex.coach);
    } else if (action == "profile") {
      navigation.pop(context);
      bottomPageController.jumpToPage(BottomBarScreenIndex.profile);
    } else {
      if (type == "plan_assigned") {
        navigation.pop(context);
        _navigateToPathwayScreen(item);
      } else {
        navigation.pop(context);
        bottomPageController.jumpToPage(BottomBarScreenIndex.home);
      }
    }
  }

  Future<void> _navigateToPathwayScreen(NotificationItem notification) async {
    PathwaysModel? model = _pathwaysModel;

    final targetContext = navigatorKey.currentContext ?? context;

    if (model == null) {
      final pathwaysBloc = BlocProvider.of<PathwaysBloc>(targetContext);
      if (pathwaysBloc.state is PathwaysSuccess) {
        model = (pathwaysBloc.state as PathwaysSuccess).model;
        _pathwaysModel = model;
      } else {
        LoaderService.show(targetContext);
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

    final String planUuid = notification.data?["plan_uuid"]?.toString() ?? "";
    final targetScreen = _resolveScreenForPathway(model, planUuid);

    final navState = navigatorKey.currentState;
    if (navState != null && navState.mounted) {
      navigation.pushSlideAnimation(
        navState.context,
        targetScreen,
        onValue: (_) {
          final currentContext = navigatorKey.currentContext;
          if (currentContext != null) {
            BlocProvider.of<DashboardBloc>(currentContext).add(
              const UserDashboardEvent(url: Urls.dashboard),
            );
          }
        },
      );
    }
  }

  Widget _resolveScreenForPathway(PathwaysModel? model, String targetUuid) {
    PathwayItem? matchedItem;

    if (model?.data?.groups != null && targetUuid.isNotEmpty) {
      for (final group in model!.data!.groups!) {
        for (final item in group.pathways ?? []) {
          if (item.uuid == targetUuid) {
            matchedItem = item;
            break;
          }
        }
        if (matchedItem != null) break;
      }
    }

    final String slug = (matchedItem?.slug ?? '').toLowerCase().trim();
    final String title = (matchedItem?.title ?? '').toLowerCase().trim();

    if (slug == "gut-reset" || title.contains("gut reset")) {
      return GutResetProtocolScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    } else if (slug == "fat-loss-inch-loss" || title.contains("fat loss") || title.contains("inch loss")) {
      return FatLossInchLossScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    } else if (slug == "healthy-weight-gain" || title.contains("weight gain")) {
      return HealthyWeightGainScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    } else if (slug == "rooted-recovery-new-moms" || title.contains("rooted recovery") || title.contains("new moms")) {
      return RootedRecoveryScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    } else if (slug == "maintenance-lifestyle" || title.contains("maintenance")) {
      return MaintenanceLifestyleScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    } else if (slug == "reproductive-life-stage" || title.contains("reproductive")) {
      return ReproductiveLifeStageScreen(pathwayUuid: matchedItem?.uuid ?? targetUuid);
    }

    return const SelectPathwayScreen(isBack: true);
  }

  String _resolveBadgeText(NotificationItem item) {
    if (item.badge != null && item.badge!.toString().trim().isNotEmpty) {
      return item.badge!.toString().trim();
    }
    final type = (item.type ?? '').toLowerCase();
    if (type == "plan_assigned") {
      return "Plan Update";
    } else if (type == "coach_note") {
      return "Coach Note";
    } else if (type == "daily_checkin") {
      return "Daily Check-in";
    } else if (type == "weekly_checkin") {
      return "Weekly Progress";
    }
    return "Notification";
  }

  Color _resolveBadgeBgColor(NotificationItem item) {
    final type = (item.type ?? '').toLowerCase();
    if (type == "plan_assigned") {
      return const Color(0xFFFFDADB);
    } else if (type == "coach_note") {
      return const Color(0xFFE8F1DC);
    }
    return const Color(0xFFF8F2EF);
  }

  Color _resolveBadgeTextColor(NotificationItem item) {
    final type = (item.type ?? '').toLowerCase();
    if (type == "plan_assigned") {
      return const Color(0xFF8B484D);
    } else if (type == "coach_note") {
      return const Color(0xFF576245);
    }
    return const Color(0xFF534343);
  }

  String _resolveButtonText(NotificationItem item) {
    final action = (item.action ?? '').toLowerCase().trim();
    final type = (item.type ?? '').toLowerCase().trim();

    if (action == "plan" || type == "plan_assigned") {
      return "View Plan";
    } else if (action == "home" || type == "coach_note") {
      return "View Details";
    } else if (action == "checkin" || action == "daily_checkin") {
      return "Log Daily Data";
    } else if (action == "progress" || action == "weekly_checkin") {
      return "View Progress";
    }
    return "Open";
  }

  String _formatCreatedAt(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return "";
    try {
      final inputDate = rawDate.trim();
      DateTime? parsed;
      final formats = [
        DateFormat('dd-MM-yyyy HH:mm:ss'),
        DateFormat('dd-MM-yyyy hh:mm:ss a'),
        DateFormat('dd-MM-yyyy HH:mm'),
        DateFormat('dd-MM-yyyy hh:mm a'),
        DateFormat('yyyy-MM-dd HH:mm:ss'),
        DateFormat('yyyy-MM-ddTHH:mm:ss'),
        DateFormat('yyyy-MM-dd'),
      ];

      for (final format in formats) {
        try {
          parsed = format.parse(inputDate);
          break;
        } catch (_) {}
      }

      parsed ??= DateTime.tryParse(inputDate);

      if (parsed != null) {
        return DateFormat('dd-MM-yyyy hh:mm a').format(parsed);
      }
    } catch (_) {}
    return rawDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      appBar: CommonAppBar(
        appBarColor: appColors.transparent,
        leading: buildInkWell(
          onTap: () => navigation.pop(context),
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back,
              size: 24,
              color: appColors.neutral,
            ),
          ),
        ),
        title: CommonText(
          "Notifications",
          fontFamily: fontPlayfairDisplay,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<MarkNotificationReadBloc, MarkNotificationReadState>(
        listener: (context, state) {
          if (state is MarkNotificationReadSuccess) {
            appPrint("Notification marked as read: ${state.model.message}");
            final currentContext = navigatorKey.currentContext;
            if (currentContext != null) {
              BlocProvider.of<DashboardBloc>(currentContext).add(
                const UserDashboardEvent(url: Urls.dashboard),
              );
            }
          } else if (state is MarkNotificationReadFailed) {
            appLog(name: "MarkNotificationRead Failed", state.message);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchNotifications();
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading || state is NotificationsInitial) {
                return _buildShimmerLoading();
              } else if (state is NotificationsFailed) {
                return _buildErrorState(state.message);
              } else if (state is NotificationsSuccess) {
                final notifications = state.model.data?.notifications ?? [];
                if (notifications.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildNotificationList(notifications);
              }
              return _buildShimmerLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(
        bottom: bottomPadding(context) + 16,
      ),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = notifications[index];
        final badgeText = _resolveBadgeText(item);
        final badgeBgColor = _resolveBadgeBgColor(item);
        final badgeTextColor = _resolveBadgeTextColor(item);
        final buttonText = _resolveButtonText(item);

        return _NotificationCard(
          badgeText: badgeText,
          badgeBgColor: badgeBgColor,
          badgeTextColor: badgeTextColor,
          title: item.title ?? "",
          body: item.body,
          createdAt: _formatCreatedAt(item.createdAt),
          isRead: item.isRead ?? false,
          buttonText: buttonText,
          onTapCard: () => _onNotificationCardTapped(item),
          onTapButton: () => _onNotificationCardTapped(item),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F2EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: Color(0xFF8B484D),
              ),
            ),
            const SizedBox(height: 20),
            CommonText(
              "No Notifications Yet",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
            ),
            const SizedBox(height: 8),
            CommonText(
              "You're all caught up! Updates from your coach and plan activities will appear here.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A7270),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFF8B484D),
            ),
            const SizedBox(height: 16),
            CommonText(
              "Unable to load notifications",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1B1A),
              ),
            ),
            const SizedBox(height: 8),
            CommonText(
              message.isNotEmpty ? message : "Something went wrong. Please try again.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A7270),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            CommonButton(
              height: 40,
              width: 140,
              btnColor: appColors.primary,
              onTap: _fetchNotifications,
              name: "Try Again",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              radius: 999,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(
        bottom: bottomPadding(context) + 16,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, _) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                Container(
                  height: 14,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 34,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String badgeText;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final String title;
  final String? body;
  final String? createdAt;
  final bool isRead;
  final String buttonText;
  final VoidCallback onTapCard;
  final VoidCallback onTapButton;

  const _NotificationCard({
    required this.badgeText,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.title,
    this.body,
    this.createdAt,
    this.isRead = false,
    required this.buttonText,
    required this.onTapCard,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          border: !isRead ? Border.all(
            color: const Color(0xFF8B484D).withValues(alpha: 0.25),
            width: 1,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: appColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: CommonText(
                        badgeText,
                        style: TextStyle(
                          color: badgeTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (!isRead) ...[
                      const SizedBox(width: 8),
                      Container(
                        height: 7,
                        width: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B484D),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                if (createdAt != null && createdAt!.isNotEmpty)
                  CommonText(
                    createdAt!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            CommonText(
              title,
              style: const TextStyle(
                color: Color(0xFF1D1B1A),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                height: 20 / 15,
              ),
            ),
            if (body != null && body!.isNotEmpty) ...[
              const SizedBox(height: 6),
              CommonText(
                body!,
                style: const TextStyle(
                  color: Color(0xFF534343),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 18 / 13,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                CommonButton(
                  height: 34,
                  btnColor: appColors.primary,
                  onTap: onTapButton,
                  name: buttonText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  icon: Icons.arrow_forward_rounded,
                  imageSize: 16,
                  isIconFirst: false,
                  radius: 999,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
