class AppImages {

  AppImages._(); /// private constructor

  static final AppImages instance = AppImages._();

  ///===========================================================================
  /// IMAGES SECTION
  ///===========================================================================
  final String basePath = "assets/images";

  String get appLogo => "$basePath/app_logo.png";
  String get splashImage => "$basePath/splash_image.png";
  String get userAvatarPlaceholder => "$basePath/user_avatar_placeholder.png";
}

