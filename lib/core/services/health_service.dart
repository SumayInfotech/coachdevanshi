import 'dart:io';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class HealthService {
  static final Health _health = Health();

  /// Platform health source: 'google_fit' on Android, 'apple_health' on iOS
  static String get source => Platform.isAndroid ? "google_fit" : "apple_health";

  /// Supported health data types per platform
  static List<HealthDataType> get _dataTypes => [
        HealthDataType.STEPS,
        if (Platform.isAndroid) HealthDataType.DISTANCE_DELTA,
        if (Platform.isIOS) HealthDataType.DISTANCE_WALKING_RUNNING,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        if (Platform.isIOS) HealthDataType.EXERCISE_TIME,
        if (Platform.isAndroid) HealthDataType.WORKOUT,
      ];

  /// Initialize and configure the Health plugin
  static Future<void> init() async {
    try {
      await _health.configure();
    } catch (e) {
      appLog(name: "HealthService init error", e.toString());
    }
  }

  /// Request authorization from user for HealthKit (iOS) or Health Connect (Android)
  static Future<bool> requestPermissions() async {
    try {
      await _health.configure();

      // On Android, verify Health Connect status
      if (Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          appLog(name: "Health Connect status", status?.name ?? "unavailable");
          await _health.installHealthConnect();
          return false;
        }
      }

      final types = _dataTypes;
      final permissions = types.map((_) => HealthDataAccess.READ).toList();

      final authorized = await _health.requestAuthorization(
        types,
        permissions: permissions,
      );

      return authorized;
    } catch (e) {
      appLog(name: "HealthService requestPermissions error", e.toString());
      return false;
    }
  }

  /// Fetch today's health metrics and return payload formatted for healthSync API:
  /// {
  ///   "source": "google_fit" | "apple_health",
  ///   "records": [
  ///     {
  ///       "date": "2026-11-16",
  ///       "steps": 7842,
  ///       "distance_km": 5.6,
  ///       "calories": 320,
  ///       "active_minutes": 48
  ///     }
  ///   ]
  /// }
  static Future<Map<String, dynamic>?> getTodayHealthSyncPayload() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        appLog("Health permissions not granted or cancelled by user");
        return null;
      }

      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // 1. Steps
      int steps = 0;
      try {
        final totalSteps = await _health.getTotalStepsInInterval(midnight, now);
        steps = totalSteps ?? 0;
      } catch (e) {
        appLog(name: "Error fetching steps", e.toString());
      }

      // 2. Distance in Kilometers
      double distanceKm = 0.0;
      try {
        final distanceType = Platform.isAndroid
            ? HealthDataType.DISTANCE_DELTA
            : HealthDataType.DISTANCE_WALKING_RUNNING;

        final distancePoints = await _health.getHealthDataFromTypes(
          types: [distanceType],
          startTime: midnight,
          endTime: now,
        );

        double totalDistanceMeters = 0.0;
        for (var point in distancePoints) {
          if (point.value is NumericHealthValue) {
            totalDistanceMeters += (point.value as NumericHealthValue).numericValue;
          }
        }

        if (totalDistanceMeters > 0) {
          distanceKm = double.parse((totalDistanceMeters / 1000.0).toStringAsFixed(2));
        } else if (steps > 0) {
          // Fallback approximate: 1 step ~ 0.75 meters
          distanceKm = double.parse(((steps * 0.75) / 1000.0).toStringAsFixed(2));
        }
      } catch (e) {
        appLog(name: "Error fetching distance", e.toString());
        if (steps > 0) {
          distanceKm = double.parse(((steps * 0.75) / 1000.0).toStringAsFixed(2));
        }
      }

      // 3. Active Calories
      int calories = 0;
      try {
        final caloriesPoints = await _health.getHealthDataFromTypes(
          types: [HealthDataType.ACTIVE_ENERGY_BURNED],
          startTime: midnight,
          endTime: now,
        );

        double totalCalories = 0.0;
        for (var point in caloriesPoints) {
          if (point.value is NumericHealthValue) {
            totalCalories += (point.value as NumericHealthValue).numericValue;
          }
        }
        calories = totalCalories.round();

        // Fallback approximate if active calories 0 but steps > 0: ~0.04 kcal per step
        if (calories == 0 && steps > 0) {
          calories = (steps * 0.04).round();
        }
      } catch (e) {
        appLog(name: "Error fetching calories", e.toString());
        if (steps > 0) {
          calories = (steps * 0.04).round();
        }
      }

      // 4. Active Minutes
      int activeMinutes = 0;
      try {
        if (Platform.isIOS) {
          final exercisePoints = await _health.getHealthDataFromTypes(
            types: [HealthDataType.EXERCISE_TIME],
            startTime: midnight,
            endTime: now,
          );
          for (var point in exercisePoints) {
            if (point.value is NumericHealthValue) {
              activeMinutes += (point.value as NumericHealthValue).numericValue.toInt();
            }
          }
        } else if (Platform.isAndroid) {
          final workoutPoints = await _health.getHealthDataFromTypes(
            types: [HealthDataType.WORKOUT],
            startTime: midnight,
            endTime: now,
          );
          for (var point in workoutPoints) {
            activeMinutes += point.dateTo.difference(point.dateFrom).inMinutes;
          }
        }

        // Fallback estimate if 0 and steps > 0: ~100 steps per active minute
        if (activeMinutes == 0 && steps > 0) {
          activeMinutes = (steps / 100).round();
        }
      } catch (e) {
        appLog(name: "Error fetching active minutes", e.toString());
        if (steps > 0) {
          activeMinutes = (steps / 100).round();
        }
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final payload = {
        "source": source,
        "records": [
          {
            "date": dateStr,
            "steps": steps,
            "distance_km": distanceKm,
            "calories": calories,
            "active_minutes": activeMinutes,
          }
        ]
      };

      appLog(name: "Generated HealthSync Payload", payload.toString());
      return payload;
    } catch (e) {
      appLog(name: "HealthService getTodayHealthSyncPayload Exception", e.toString());
      return null;
    }
  }
}
