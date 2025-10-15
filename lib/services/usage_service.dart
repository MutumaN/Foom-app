import 'package:flutter/services.dart';

class UsageService {
  static const platform = MethodChannel('com.foom.app.v2/usage');

  // Request Usage Access Permission
  static Future<bool> requestUsageAccess() async {
    try {
      final bool granted = await platform.invokeMethod('requestUsageAccess');
      return granted;
    } catch (e) {
      return false;
    }
  }

  // Check if Usage Access is Granted
  static Future<bool> hasUsageAccess() async {
    try {
      final bool hasAccess = await platform.invokeMethod('hasUsageAccess');
      return hasAccess;
    } catch (e) {
      return false;
    }
  }

  // Get Daily Usage in Minutes
  static Future<int> getDailyUsage() async {
    try {
      final int minutes = await platform.invokeMethod('getDailyUsage');
      return minutes;
    } catch (e) {
      return 0;
    }
  }

  // Get Weekly Usage (last 7 days)
  static Future<Map<String, int>> getWeeklyUsage() async {
    try {
      final Map<dynamic, dynamic> usage = 
          await platform.invokeMethod('getWeeklyUsage');
      return usage.map((key, value) => MapEntry(key.toString(), value as int));
    } catch (e) {
      return {};
    }
  }

  // Get App Usage (per-app breakdown)
  static Future<List<AppUsage>> getAppUsage() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getAppUsage');
      return apps.map((app) => AppUsage.fromJson(app)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get Yesterday's Usage
  static Future<int> getYesterdayUsage() async {
    try {
      final int minutes = await platform.invokeMethod('getYesterdayUsage');
      return minutes;
    } catch (e) {
      return 0;
    }
  }

  // Calculate Tokens Earned
  static int calculateTokens(int todayMinutes, int yesterdayMinutes) {
    if (todayMinutes >= yesterdayMinutes) return 0;
    
    final reduction = yesterdayMinutes - todayMinutes;
    return (reduction / 10).floor(); // 1 token per 10 minutes reduced
  }
}

class AppUsage {
  final String packageName;
  final String appName;
  final String? icon;
  final int usageMinutes;

  AppUsage({
    required this.packageName,
    required this.appName,
    this.icon,
    required this.usageMinutes,
  });

  factory AppUsage.fromJson(Map<dynamic, dynamic> json) {
    return AppUsage(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      icon: json['icon'] as String?,
      usageMinutes: json['usageMinutes'] as int,
    );
  }
}

