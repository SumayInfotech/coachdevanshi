import 'package:flutter/material.dart';

import '../../core/constants/utils.dart';
import '../../main.dart';
import 'splash/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: appName,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: fontFamilyPlusJakartaSans,
        colorScheme: .fromSeed(seedColor: appColors.primary),
        scaffoldBackgroundColor: appColors.white,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: appColors.primary,
          selectionColor: appColors.primary.withValues(alpha: 0.25),
          selectionHandleColor: appColors.primary,
        ),
      ),
      home: SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: .linear(1.0)),
          child: child!,
        );
      },
    );
  }
}