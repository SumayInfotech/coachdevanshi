import 'package:shared_preferences/shared_preferences.dart';

///
///  Use this class Before
///
///  Make async void main function and write this code
///
///  [WidgetsFlutterBinding.ensureInitialized();]
///  [await AppPreferences.init();]
///

class AppPreferences {
  AppPreferences._();

  static late SharedPreferences _prefs;

  /// Keys
  static const String isIntro = 'isIntro';
  static const String isLogin = 'isLogin';
  static const String accessToken = 'accessToken';
  static const String fcmToken = 'fcmToken';
  static const String isNotificationEnabled = 'isNotificationEnabled';

  /// Initialize
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception(
        'AppPreferences is not initialized. Call AppPreferences.init() in main().',
      );
    }
  }

  static bool get _isInitialized {
    try {
      _prefs;
      return true;
    } catch (_) {
      return false;
    }
  }

  // ===========================
  // SET METHODS
  // ===========================

  static Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  static Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  static Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  static Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
  static Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  // ===========================
  // GET METHODS
  // ===========================

  static bool getBool(String key, {bool defaultValue = false}) {
    _checkInitialization();
    return _prefs.getBool(key) ?? defaultValue;
  }

  static String getString(String key, {String defaultValue = ''}) {
    _checkInitialization();
    return _prefs.getString(key) ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    _checkInitialization();
    return _prefs.getInt(key) ?? defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    _checkInitialization();
    return _prefs.getDouble(key) ?? defaultValue;
  }

  static List<String> getStringList(String key) {
    _checkInitialization();
    return _prefs.getStringList(key) ?? [];
  }

  static T? getValue<T>(String key) {
    _checkInitialization();
    return _prefs.get(key) as T?;
  }

  // ===========================
  // REMOVE METHODS
  // ===========================

  static Future<bool> remove({required String key}) => _prefs.remove(key);
  static Future<bool> clearAllPreferences() => _prefs.clear();
  static Future<void> clearPreferences() async {
    await _prefs.remove(isLogin);
    await _prefs.remove(accessToken);
    await _prefs.remove(fcmToken);
    await _prefs.remove(isNotificationEnabled);
  }

  // ===========================
  // NULLABLE BOOL
  // ===========================

  static Future<void> setNullableBool(String key, bool? value) async {
    if (value == null) {
      await remove(key: key);
    } else {
      await setBool(key, value);
    }
  }

  // ===========================
  // LOGIN HELPERS
  // ===========================

  static Future<void> logout() async {
    await remove(key: accessToken);
    await remove(key: isLogin);
  }

}
