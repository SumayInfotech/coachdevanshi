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
  static const onboardingMasters = "$baseUrl/onboarding-masters";
}