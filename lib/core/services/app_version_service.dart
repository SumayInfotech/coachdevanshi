import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService {
  // Private constructor
  AppVersionService._internal();

  // Singleton instance
  static final AppVersionService instance = AppVersionService._internal();

  // Factory constructor
  factory AppVersionService() => instance;

  static String? _version;
  static String? _buildNumber;
  static String? _appName;
  static String? _packageName;

  /// Initializes and caches app version info.
  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
    _buildNumber = info.buildNumber;
    _appName = info.appName;
    _packageName = info.packageName;
  }

  String get version => _version ?? 'Unknown';
  String get buildNumber => _buildNumber ?? 'Unknown';
  String get appName => _appName ?? 'Unknown';
  String get packageName => _packageName ?? 'Unknown';

  /// Returns version in `vX.Y.Z` format
  String get fullVersion => 'v$version';
}