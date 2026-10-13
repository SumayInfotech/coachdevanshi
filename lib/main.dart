import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_icons.dart';
import 'core/constants/app_images.dart';
import 'core/services/app_version_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/preference_service.dart';
import 'ui/screens/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   appLog("Firebase Initialize Success");
  // } catch (e) {
  //   appLog("Firebase Initialize Failed ::-> ${e.toString()}");
  // }
  await AppPreferences.init();
  await AppVersionService.init();
  AppColors.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

late double height;
late double width;

final appImages = AppImages.instance;
final appColors = AppColors.instance;
final appIcons = AppIcons.instance;
final navigation = NavigationService.instance;
final appVersion = AppVersionService.instance;
// final url = Urls.instance;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void appPrint(String msg) {
  if (kDebugMode) {
    debugPrint(msg);
  }
}

void appLog(String msg, {String? name}) {
  if (kDebugMode) {
    log(name: name ?? "", msg);
  }
}