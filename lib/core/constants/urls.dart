class Urls {

  static const baseUrl = "https://coach-devanshi-doshi.websitetestplace.in/api/v1";

  static const signUp = "$baseUrl/auth/signup";
  static const signUpVerifyOTP = "$baseUrl/auth/verify-signup-otp";
  static const resendSignUpOtp = "$baseUrl/auth/resend-signup-otp";

  static const socialLogin = "$baseUrl/auth/social-login";
  static const login = "$baseUrl/auth/login";
  static const loginVerifyOTP = "$baseUrl/auth/login-signup-verify-otp";

  static const profile = "$baseUrl/get-profile";
  static const logout = "$baseUrl/logout";

  static const getLocation = "$baseUrl/get-location";

  // On Boarding Status
  static const onboardingStatus = "$baseUrl/onboarding/status";
  static const onboardingMasters = "$baseUrl/onboarding-masters";
  static String onboardingChapter({required String chapterId}) => "$baseUrl/onboarding/chapters/$chapterId";

  static const dashboard = "$baseUrl/dashboard";


  static const dailyCheckins = "$baseUrl/daily-checkins";
  static String dailyCheck({required String date}) => "$baseUrl/daily-checkins/$date";

  static const weeklyCheckins = "$baseUrl/weekly-checkins";
  static String weeklyCheck({required String date}) => "$baseUrl/weekly-checkins/$date";
  static const progressPhotos = "$baseUrl/progress-photos";
  static const getProgressPhotos = "$baseUrl/progress-photos";
  static const foodDiary = "$baseUrl/food-diary";
  static const getFoodDiary = "$baseUrl/food-diary";

  static const bloodReports = "$baseUrl/blood-reports";
  static const getBloodReports = "$baseUrl/blood-reports";
  static String deleteFileBloodReports({required String id}) => "$baseUrl/blood-reports/files/$id/delete";


  static const pathways = "$baseUrl/pathways";
  static String pathwaysProtocol({required String pathwayUuid}) => "$baseUrl/pathways/$pathwayUuid/protocol";

  static const healthSync = "$baseUrl/health/sync";
}
