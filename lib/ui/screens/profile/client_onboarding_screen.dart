import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../core/blocs/auth/logout/logout_bloc.dart';
import '../../../core/blocs/profile/onboarding_masters/onboarding_masters_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/loader_service.dart';
import '../../../core/services/preference_service.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import '../check-in/daily_wellness_log_screen.dart';
import '../coach/fat_loss_inch_loss_screen.dart';
import '../progress/baseline_progress_screen.dart';
import 'blood_report_upload_screen.dart';
import '../progress/three_day_food_diary_screen.dart';
import '../progress/track_weekly_progress_screen.dart';
import '../splash/welcome_screen.dart';
import 'food_digestion_intake_screen.dart';
import 'goals_starting_point_screen.dart';
import 'health_safety_intake_screen.dart';
import 'lifestyle_coaching_fit_screen.dart';
import 'mindset_sustainability_screen.dart';
import 'profile_program_selection_screen.dart';

class ClientOnboardingScreen extends StatefulWidget {
  final bool isBack;
  final bool isLogin;
  const ClientOnboardingScreen({super.key, this.isBack = false, this.isLogin = false});

  @override
  State<ClientOnboardingScreen> createState() => _ClientOnboardingScreenState();
}

class _ClientOnboardingScreenState extends State<ClientOnboardingScreen> {
  ValueNotifier<OnboardingMastersModel?> onboardingMastersModel = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    callOnboardingMastersAPI();
  }

  void _onBack(BuildContext context) {
    if (widget.isBack) {
      navigation.pop(context);
    } else {
      bottomPageController.jumpToPage(BottomBarScreenIndex.home);
    }
  }

  void callOnboardingMastersAPI() {
    BlocProvider.of<OnboardingMastersBloc>(context).add(
      UserOnboardingMastersEvent(url: Urls.onboardingMasters),
    );
  }

  void callLogout() async {
    await AuthServices.signOut();
    AppPreferences.clearPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final String displayDate = DateFormat('EEEE, MMMM dd').format(DateTime.now());

    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              callLogout();
              showSnackBar(context: context, isError: false, message: state.model.message ?? "");
              LoaderService.hide();
              navigation.pushAndRemoveUntilSlideAnimation(context, const WelcomeScreen());
            } else if (state is LogoutFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<OnboardingMastersBloc, OnboardingMastersState>(
          listener: (context, state) {
            if (state is OnboardingMastersSuccess) {
              LoaderService.hide();
              onboardingMastersModel.value = state.model;
            } else if (state is OnboardingMastersFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
      ],
      child: PopScope(
        canPop: widget.isBack,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _onBack(context);
        },
        child: Scaffold(
          backgroundColor: appColors.bgColor,
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: onboardingMastersModel,
              builder: (context, onboardingMasters, _) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Top Bar (Profile)
                    Row(
                      children: [
                        if (widget.isBack)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: buildInkWell(
                              onTap: () => _onBack(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                  color: appColors.neutral,
                                ),
                              ),
                            ),
                          ),
                        const CommonText(
                          "Profile",
                          style: TextStyle(
                            fontSize: 26,
                            color: Color(0xFF1D1B1A),
                            fontWeight: FontWeight.w700,
                          ),
                          fontFamily: 'serif',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Greeting Banner
                    CommonText(
                      displayDate.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF534343),
                        letterSpacing: 0.55,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    const SizedBox(height: 4),
                    ValueListenableBuilder(
                      valueListenable: userData,
                      builder: (context, user, _) {
                        return CommonText(
                          "Good morning, ${user?.name?.split(" ").first ?? "Ananya"}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D1B1A),
                            height: 1.3,
                          ),
                          fontFamily: 'serif',
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Onboarding Journey Progress Banner
                    _buildOnboardingJourneyBanner(),
                    const SizedBox(height: 16),

                    // 6 Chapter Cards
                    _ChapterCard(
                      chapterNumber: "CHAPTER 01",
                      title: "Profile & Program",
                      subtitle: "Gut Reset & Digestive Ease",
                      isComplete: false,
                      icon: appIcons.profileProgram,
                      iconBgColor: const Color(0xFFD8E5BF),
                      iconColor: const Color(0xFF5B6749),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        ProfileProgramSelectionScreen(
                          coachingJourney: onboardingMasters?.data?.coachingJourney ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _ChapterCard(
                      chapterNumber: "CHAPTER 02",
                      title: "Goals& Starting Point",
                      subtitle: "Better digestion & energy vitality",
                      isComplete: true,
                      icon: appIcons.goalsStartingPoint,
                      iconBgColor: const Color(0xFFFFDADB),
                      iconColor: const Color(0xFF8B484D),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        GoalsStartingPointScreen(
                          approachesTried: onboardingMasters?.data?.approachesTried ?? [],
                          confidentAreas: onboardingMasters?.data?.confidentAreas ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _ChapterCard(
                      chapterNumber: "CHAPTER 03",
                      title: "Relevant Health & Safety",
                      subtitle: "Acid reflux · Physician cleared",
                      isComplete: true,
                      icon: appIcons.relevantHealthSafety,
                      iconBgColor: const Color(0xFFD8E5BF),
                      iconColor: const Color(0xFF5B6749),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        HealthSafetyIntakeScreen(
                          medicalDiagnoses: onboardingMasters?.data?.medicalDiagnoses ?? [],
                          familyMedicalHistory: onboardingMasters?.data?.familyMedicalHistory ?? [],
                          recentClinicalSymptoms: onboardingMasters?.data?.recentClinicalSymptoms ?? [],
                          allergiesIntolerances: onboardingMasters?.data?.allergiesIntolerances ?? [],
                          hormonalLifeStage: onboardingMasters?.data?.hormonalLifeStage ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _ChapterCard(
                      chapterNumber: "CHAPTER 04",
                      title: "Food & Digestion",
                      subtitle: "Plant-forward · Structured rhythm",
                      isComplete: true,
                      icon: appIcons.foodDigestion,
                      iconBgColor: const Color(0xFFFFDADB),
                      iconColor: const Color(0xFF8B484D),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        FoodDigestionIntakeScreen(
                          eatingPattern: onboardingMasters?.data?.eatingPattern ?? [],
                          culturalFastingPractices: onboardingMasters?.data?.culturalFastingPractices ?? [],
                          foodEnvWhoCooks: onboardingMasters?.data?.foodEnvWhoCooks ?? [],
                          foodEnvSupportLevel: onboardingMasters?.data?.foodEnvSupportLevel ?? [],
                          foodEnvMealsOutPerWeek: onboardingMasters?.data?.foodEnvMealsOutPerWeek ?? [],
                          intakeFruit: onboardingMasters?.data?.intakeFruit ?? [],
                          intakeVegetables: onboardingMasters?.data?.intakeVegetables ?? [],
                          intakeWater: onboardingMasters?.data?.intakeWater ?? [],
                          intakeCaffeine: onboardingMasters?.data?.intakeCaffeine ?? [],
                          intakeSugary: onboardingMasters?.data?.intakeSugary ?? [],
                          substanceHabits: onboardingMasters?.data?.substanceHabits ?? [],
                          digestiveHealth: onboardingMasters?.data?.digestiveHealth ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _ChapterCard(
                      chapterNumber: "CHAPTER 05",
                      title: "Lifestyle & Coaching Fit",
                      subtitle: "7.5k steps · 7.5h restorative sleep",
                      isComplete: true,
                      icon: appIcons.lifestyleCoaching,
                      iconBgColor: const Color(0xFFD8E5BF),
                      iconColor: const Color(0xFF5B6749),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        LifestyleCoachingFitScreen(
                          sleepNightWaking: onboardingMasters?.data?.sleepNightWaking ?? [],
                          sleepFirstHour: onboardingMasters?.data?.sleepFirstHour ?? [],
                          activityLevel: onboardingMasters?.data?.activityLevel ?? [],
                          activityDailySteps: onboardingMasters?.data?.activityDailySteps ?? [],
                          activityWorkoutsPerWeek: onboardingMasters?.data?.activityWorkoutsPerWeek ?? [],
                          activityAvailableDays: onboardingMasters?.data?.activityAvailableDays ?? [],
                          stressFirstChanges: onboardingMasters?.data?.stressFirstChanges ?? [],
                          readinessScore: onboardingMasters?.data?.readinessScore ?? [],
                          consistencyInterrupters: onboardingMasters?.data?.consistencyInterrupters ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _ChapterCard(
                      chapterNumber: "CHAPTER 06",
                      title: "Mindset & Sustainability",
                      subtitle: "Self-talk & Setting realistic commitments",
                      isComplete: true,
                      icon: appIcons.mindset,
                      iconBgColor: const Color(0xFFFFDADB),
                      iconColor: const Color(0xFF8B484D),
                      onTapButton: () => navigation.pushSlideAnimation(
                        context,
                        MindsetSustainabilityScreen(
                          goalMindset: onboardingMasters?.data?.goalMindset ?? [],
                        ),
                      ),
                    ),

                    if(!widget.isLogin)...[
                      const SizedBox(height: 20),

                      // Active Program Card
                      _buildActiveProgramSection(context),
                      const SizedBox(height: 16),

                      // Action / Tracking Cards (5 cards)
                      _ActionCard(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFDADB).withValues(alpha: 0.5),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: appColors.primary,
                            ),
                          ),
                        ),
                        title: "Three-day Food Diary",
                        subtitle: "Three-day food diary with one weekend day",
                        buttonText: "Edit",
                        isPrimaryButton: false,
                        onTapButton: () => navigation.pushSlideAnimation(
                          context,
                          const ThreeDayFoodDiaryScreen(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _ActionCard(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                          ),
                          child: Center(
                            child: Image.asset(
                              appIcons.homeMicroCheckinIcon,
                              width: 18,
                              height: 18,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: "Micro Check-in",
                        subtitle: "First seven days of steps, sleep and water baseline",
                        badgeText: "Due",
                        buttonText: "Add Data",
                        isPrimaryButton: true,
                        onTapButton: () => navigation.pushSlideAnimation(context,
                          const DailyWellnessLogScreen(isBack: true),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _ActionCard(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                          ),
                          child: Center(
                            child: Image.asset(
                              appIcons.progress,
                              width: 18,
                              height: 18,
                              color: appColors.primary,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: "Baseline and Progress Measurements",
                        subtitle: "First seven days of steps, sleep and water baseline",
                        badgeText: "Due",
                        buttonText: "Add Data",
                        isPrimaryButton: true,
                        onTapButton: () => navigation.pushSlideAnimation(
                          context,
                          const BaselineProgressScreen(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _ActionCard(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                          ),
                          child: Center(
                            child: Image.asset(
                              appIcons.addPhoto,
                              width: 18,
                              height: 18,
                              color: appColors.primary,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: "Progress Photos",
                        subtitle: "Upload Progress photos to monitor your coaching progress",
                        buttonText: "Add Photos",
                        isPrimaryButton: true,
                        onTapButton: () => navigation.pushSlideAnimation(
                          context,
                          const TrackWeeklyProgressScreen(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _ActionCard(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFDADB).withValues(alpha: 0.6),
                          ),
                          child: Center(
                            child: Image.asset(
                              appIcons.reportUpload,
                              width: 18,
                              height: 18,
                              color: appColors.primary,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: "Blood Report Upload",
                        subtitle: "Blood-report upload with report date",
                        buttonText: "Add Reports",
                        isPrimaryButton: true,
                        onTapButton: () => navigation.pushSlideAnimation(
                          context,
                          const BloodReportUploadScreen(isBack: true),
                        ),
                      ),
                    ],

                    // Log Out Button
                    const SizedBox(height: 24),
                    buildInkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        commonDialog(
                          context: context,
                          icon: Icons.logout,
                          title: "Log Out",
                          subtitle:
                              "Are you sure you want to log out? You will need to sign back in to continue your progress.",
                          onPressed: () {
                            LoaderService.show(context);
                            BlocProvider.of<LogoutBloc>(context).add(
                              UserLogoutEvent(
                                url: Urls.logout,
                                body: {
                                  "fcm_token": AppPreferences.getString(AppPreferences.fcmToken),
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F2EF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 20,
                              color: appColors.primary,
                            ),
                            const SizedBox(width: 8),
                            CommonText(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: appColors.primary,
                              ),
                              fontFamily: fontFamilyPlusJakartaSans,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: bottomPadding(context) + 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingJourneyBanner() {
    int completed = 4, total = 6;
    return Container(
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                width: 176,
                height: 176,
                decoration: const BoxDecoration(
                  color: Color(0x99D8E5BF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -48,
            left: -48,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                width: 192,
                height: 192,
                decoration: const BoxDecoration(
                  color: Color(0x80FFDADB),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: appColors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(appIcons.lotas, height: 16, width: 16, color: appColors.primary),
                          const SizedBox(width: 6),
                          const CommonText(
                            "Onboarding Journey",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B1A),
                              letterSpacing: 0.24,
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (completed >= total) ...[
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 15,
                              color: Color(0xFF5B6749),
                            ),
                            const SizedBox(width: 4),
                            const CommonText(
                              "Complete",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF5B6749),
                                letterSpacing: 0.33,
                              ),
                              fontFamily: fontFamilyPlusJakartaSans,
                            ),
                          ] else ...[
                            CommonText(
                              "$completed of $total Completed",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF576245),
                                letterSpacing: 0.33,
                              ),
                              fontFamily: fontFamilyPlusJakartaSans,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 7,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2EDEB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: appColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProgramSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Program Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD8E5BF).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF404A2F),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const CommonText(
                  "Active Program",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF404A2F),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Program Title
          GestureDetector(
            onTap: () => navigation.pushSlideAnimation(
              context,
              const FatLossInchLossScreen(),
            ),
            child: const CommonText(
              "Fat Loss & Inch Loss",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1B1A),
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ),
          const SizedBox(height: 14),

          // Height & Weight Row
          Row(
            children: [
              // Height Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        appIcons.measurement,
                        width: 20,
                        height: 20,
                        color: appColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CommonText("Height",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6D615C),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                          SizedBox(height: 2),
                          CommonText("165 cm",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Weight Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        appIcons.weight,
                        width: 20,
                        height: 20,
                        color: appColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CommonText("Weight",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6D615C),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                          SizedBox(height: 2),
                          CommonText("64.5 kg",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Connected Health & Wearables Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.watch_rounded,
                      color: appColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CommonText(
                            "Connected Health & Wearables",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1B1A),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                          SizedBox(height: 2),
                          CommonText(
                            "Apple Health & Google Fit Active Sync",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6D615C),
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF404A2F),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const CommonText(
                          "6,850 steps tracked today",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF534343),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => appLog("Sync Now tapped"),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EDEB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const CommonText("Sync Now",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF302826),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final String chapterNumber;
  final String title;
  final String subtitle;
  final bool isComplete;
  final String icon;
  final Color? iconBgColor;
  final Color? iconColor;
  final VoidCallback onTapButton;

  const _ChapterCard({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.icon,
    this.iconBgColor,
    this.iconColor,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    final String effectiveButtonText = (isComplete ? "Edit" : "Start");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(icon,
              color: iconColor ?? const Color(0xFF292726),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CommonText(
                      chapterNumber,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: appColors.primary,
                        letterSpacing: 0.55,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      isComplete ? appIcons.complete : appIcons.pending,
                      height: isComplete ? 12 : 13, width: isComplete ? 12 : 13,
                      color: Color(0xFF5B6749),
                    ),
                    const SizedBox(width: 4),
                    CommonText(
                      isComplete ? "Complete" : "Pending",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isComplete ? Color(0xFF5B6749) : Color(0xFF857373),
                        letterSpacing: 0.33,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CommonText(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF292726),
                    letterSpacing: -0.5,
                  ),
                  fontFamily: 'serif',
                ),
                const SizedBox(height: 4),
                CommonText(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6D615C),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onTapButton,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isComplete ? appColors.textFieldBgColor : appColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText(
                effectiveButtonText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? appColors.primary : appColors.white,
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final String? badgeText;
  final String buttonText;
  final bool isPrimaryButton;
  final VoidCallback onTapButton;

  const _ActionCard({
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.buttonText,
    required this.isPrimaryButton,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                const SizedBox(height: 4),
                CommonText(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6D615C),
                    height: 1.35,
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onTapButton,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: isPrimaryButton ? appColors.primary : const Color(0xFFF8F2F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: CommonText(
                      buttonText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPrimaryButton ? appColors.white : appColors.primary,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDADB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CommonText(
                badgeText!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF713439),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
