import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import 'preference_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static FlutterLocalNotificationsPlugin get notificationsPlugin => _notificationsPlugin;

  static Future<void> askNotificationPermission() async {
    await NotificationService.initializeFCM();
  }

  /// Initialize Local Notifications and FCM Listeners
  static Future<void> initializeFCM() async {
    await _initLocalNotifications();
    await _requestPermissions();

    /// ADD THIS: Force iOS to show the native banner in the foreground
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    _initFirebaseMessagingListeners();

    /// Get the FCM token (use this to send notifications to this device)
    String? token = await FirebaseMessaging.instance.getToken();
    AppPreferences.setString(AppPreferences.fcmToken, token ?? "");
    appPrint("FCM Token: $token");

    /// Handle when app is terminated and opened via notification
    // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleNotificationClick(initialMessage.data);
    // }
  }

  /// Local Notifications initialization
  static Future<void> _initLocalNotifications() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      web: WebInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        appPrint('Notification clicked: ${details.payload}');
        if (details.payload != null) {
          _handleNotificationClick(jsonDecode(details.payload!));
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
    );

    if(kIsWeb) {
      final webPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<WebFlutterLocalNotificationsPlugin>();
      if (webPlugin != null && webPlugin.permissionStatus != WebNotificationPermission.granted) {
        await webPlugin.requestNotificationsPermission();
      }
      return ;
    } else {
      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request permissions for iOS and Android 13+
  static Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final bool isPermissionGranted = await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission() ?? false;

      if (isPermissionGranted) {
        AppPreferences.setBool(AppPreferences.isNotificationEnabled, true);
      } else {
        AppPreferences.setBool(AppPreferences.isNotificationEnabled, false);
      }
    }
  }

  /// Setup FCM message listeners
  static Future<void> _initFirebaseMessagingListeners() async {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      appPrint("Foreground: ${message.notification?.title}");
      if (Platform.isAndroid) {
        display(message);
      }
    });

    /// Background & tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      appPrint("Notification clicked (background) :1: ${message.data}");
      _handleNotificationClick(message.data);
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(Duration(seconds: 1), () {
        appPrint("Notification clicked (background) :2: ${initialMessage.data}");
        _handleNotificationClick(initialMessage.data);
      });
    }
  }

  /// Display notification using flutter_local_notifications
  static Future<void> display(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = notification?.android;

      final bigTextStyleInformation = BigTextStyleInformation(
        notification?.body ?? '',
        contentTitle: notification?.title ?? '',
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
      );

      final NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          android?.channelId ?? 'default_channel',
          android?.channelId ?? 'General Notifications',
          channelDescription: 'Used for general notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: bigTextStyleInformation,
          audioAttributesUsage: AudioAttributesUsage.notification,
          color: appColors.primary,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification?.title ?? 'No Title',
        body: notification?.body ?? 'No Body',
        notificationDetails: details,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      appPrint('Error displaying notification: $e');
    }
  }

  /// Handle notification click logic
  static void _handleNotificationClick(Map<String, dynamic> data) {
    debugPrint("Navigate to screen with data: $data");
  }
}
