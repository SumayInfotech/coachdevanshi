import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../repository/auth_repo.dart';
import '../repository/coach_repo.dart';
import '../repository/home_repo.dart';
import '../repository/profile_repo.dart';
import '../repository/progress_repo.dart';

import 'auth/login/login_bloc.dart';
import 'auth/logout/logout_bloc.dart';
import 'auth/profile/profile_bloc.dart';
import 'auth/resend_sign_up_otp/resend_sign_up_otp_bloc.dart';
import 'auth/sign_up/sign_up_bloc.dart';
import 'auth/social_login/social_login_bloc.dart';
import 'auth/verify_otp/verify_otp_bloc.dart';
import 'coach/fat_loss_inch_loss/fat_loss_inch_loss_bloc.dart';
import 'coach/gut_reset/gut_reset_bloc.dart';
import 'coach/healthy_weight_gain/healthy_weight_gain_bloc.dart';
import 'coach/maintenance_lifestyle/maintenance_lifestyle_bloc.dart';
import 'coach/pathways/pathways_bloc.dart';
import 'coach/reproductive_life_stage/reproductive_life_stage_bloc.dart';
import 'coach/rooted_recovery_new_moms/rooted_recovery_new_moms_bloc.dart';
import 'coach/save_protocol_form/save_protocol_form_bloc.dart';
import 'home/dashboard/dashboard_bloc.dart';
import 'profile/chapter_two/chapter_two_bloc.dart';
import 'profile/chapter_three/chapter_three_bloc.dart';
import 'profile/location/location_bloc.dart';
import 'profile/chapter_one/chapter_one_bloc.dart';
import 'profile/onboarding_masters/onboarding_masters_bloc.dart';
import 'profile/onboarding_masters_status/onboarding_masters_status_bloc.dart';
import 'profile/save_chapter/save_chapter_bloc.dart';
import 'profile/chapter_four/chapter_four_bloc.dart';
import 'profile/chapter_five/chapter_five_bloc.dart';
import 'profile/chapter_six/chapter_six_bloc.dart';
import 'profile/upload_blood_report/upload_blood_report_bloc.dart';
import 'profile/get_blood_reports/get_blood_reports_bloc.dart';
import 'profile/delete_file_blood_reports/delete_file_blood_reports_bloc.dart';
import 'home/daily_checkin/daily_checkin_bloc.dart';
import 'home/save_daily_checkin/save_daily_checkin_bloc.dart';
import 'home/health_sync/health_sync_bloc.dart';
import 'progress/save_weekly_checkin/save_weekly_checkin_bloc.dart';
import 'progress/upload_progress_photos/upload_progress_photos_bloc.dart';
import 'progress/save_food_diary/save_food_diary_bloc.dart';
import 'progress/get_food_diary/get_food_diary_bloc.dart';
import 'progress/weekly_checkin/weekly_checkin_bloc.dart';
import 'progress/get_progress_photos/get_progress_photos_bloc.dart';

List<SingleChildWidget> blocProviders() {

  final AuthRepo authRepo = AuthRepo();
  final ProfileRepo profileRepo = ProfileRepo();
  final HomeRepo homeRepo = HomeRepo();
  final ProgressRepo progressRepo = ProgressRepo();
  final CoachRepo coachRepo = CoachRepo();

  return [

    /// Auth Blocs
    ...[
      BlocProvider(
        create: (context) => SignUpBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => SocialLoginBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => LoginBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => VerifyOTPBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => ResendSignUpOtpBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => ProfileBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => LogoutBloc(authRepo: authRepo),
      ),
    ],

    /// Profile Blocs
    ...[
      BlocProvider(
        create: (context) => LocationBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => OnboardingMastersBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => OnboardingMasterStatusBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterOneBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => SaveChapterBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterTwoBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterThreeBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterFourBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterFiveBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => ChapterSixBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => UploadBloodReportBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => GetBloodReportsBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => DeleteFileBloodReportsBloc(profileRepo: profileRepo),
      ),
    ],

    /// Home Blocs
    ...[
      BlocProvider(
        create: (context) => DashboardBloc(homeRepo: homeRepo),
      ),
      BlocProvider(
        create: (context) => DailyCheckinBloc(homeRepo: homeRepo),
      ),
      BlocProvider(
        create: (context) => SaveDailyCheckinBloc(homeRepo: homeRepo),
      ),
      BlocProvider(
        create: (context) => HealthSyncBloc(homeRepo: homeRepo),
      ),
    ],

    /// Progress Blocs
    ...[
      BlocProvider(
        create: (context) => SaveWeeklyCheckinBloc(progressRepo: progressRepo),
      ),
      BlocProvider(
        create: (context) => UploadProgressPhotosBloc(progressRepo: progressRepo),
      ),
      BlocProvider(
        create: (context) => SaveFoodDiaryBloc(progressRepo: progressRepo),
      ),
      BlocProvider(
        create: (context) => WeeklyCheckinBloc(progressRepo: progressRepo),
      ),
      BlocProvider(
        create: (context) => GetProgressPhotosBloc(progressRepo: progressRepo),
      ),
      BlocProvider(
        create: (context) => GetFoodDiaryBloc(progressRepo: progressRepo),
      ),
    ],

    /// Coach Blocs
    ...[
      BlocProvider(
        create: (context) => PathwaysBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => GutResetBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => FatLossInchLossBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => HealthyWeightGainBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => RootedRecoveryNewMomsBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => MaintenanceLifestyleBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => ReproductiveLifeStageBloc(coachRepo: coachRepo),
      ),
      BlocProvider(
        create: (context) => SaveProtocolFormBloc(coachRepo: coachRepo),
      ),
    ],
  ];
}