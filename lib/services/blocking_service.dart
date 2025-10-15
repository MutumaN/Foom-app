import 'package:flutter/services.dart';

class BlockingService {
  static const platform = MethodChannel('com.foom.app.v2/blocking');

  // Request Accessibility Permission
  static Future<bool> requestAccessibilityPermission() async {
    try {
      final bool granted = await platform.invokeMethod('requestAccessibility');
      return granted;
    } catch (e) {
      return false;
    }
  }

  // Check if Accessibility is Enabled
  static Future<bool> hasAccessibilityPermission() async {
    try {
      final bool hasAccess = await platform.invokeMethod('hasAccessibility');
      return hasAccess;
    } catch (e) {
      return false;
    }
  }

  // Block an App
  static Future<void> blockApp(String packageName) async {
    try {
      await platform.invokeMethod('blockApp', {'package': packageName});
    } catch (e) {
      throw Exception('Failed to block app: $e');
    }
  }

  // Unblock an App
  static Future<void> unblockApp(String packageName) async {
    try {
      await platform.invokeMethod('unblockApp', {'package': packageName});
    } catch (e) {
      throw Exception('Failed to unblock app: $e');
    }
  }

  // Check if App is Blocked
  static Future<bool> isAppBlocked(String packageName) async {
    try {
      final bool blocked = await platform.invokeMethod(
        'isAppBlocked',
        {'package': packageName},
      );
      return blocked;
    } catch (e) {
      return false;
    }
  }

  // Get All Blocked Apps
  static Future<List<String>> getBlockedApps() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getBlockedApps');
      return apps.cast<String>();
    } catch (e) {
      return [];
    }
  }

  // Block Multiple Apps
  static Future<void> blockApps(List<String> packageNames) async {
    for (final package in packageNames) {
      await blockApp(package);
    }
  }

  // Unblock Multiple Apps
  static Future<void> unblockApps(List<String> packageNames) async {
    for (final package in packageNames) {
      await unblockApp(package);
    }
  }

  // Set Daily Time Limit
  static Future<void> setDailyLimit(int minutes) async {
    try {
      await platform.invokeMethod('setDailyLimit', {'minutes': minutes});
    } catch (e) {
      throw Exception('Failed to set daily limit: $e');
    }
  }

  // Show Blocked App Overlay
  static Future<void> showBlockedOverlay(String appName) async {
    try {
      await platform.invokeMethod('showOverlay', {'appName': appName});
    } catch (e) {
      // Ignore errors
    }
  }
}

