import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firebase_service.dart';
import 'services/usage_service.dart';
import 'services/blocking_service.dart';
import 'services/payment_service.dart';

// Service Providers
final firebaseServiceProvider = Provider((ref) => FirebaseService());
final usageServiceProvider = Provider((ref) => UsageService());
final blockingServiceProvider = Provider((ref) => BlockingService());
final paymentServiceProvider = Provider((ref) => PaymentService());

// Auth Providers
final authStateProvider = StreamProvider<User?>((ref) {
  try {
    return ref.watch(firebaseServiceProvider).authStateChanges;
  } catch (e) {
    print('Auth state error: $e');
    // Return a stream that emits null when Firebase is not available
    return Stream.value(null);
  }
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// User Data Provider
final userDataProvider = StreamProvider<DocumentSnapshot?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  
  return ref.watch(firebaseServiceProvider).getUserData(user.uid);
});

// Tokens Provider
final tokensProvider = Provider<int>((ref) {
  final userData = ref.watch(userDataProvider).value;
  if (userData == null || !userData.exists) return 0;
  
  return (userData.data() as Map<String, dynamic>)['tokens'] ?? 0;
});

// Savings Balance Provider
final savingsBalanceProvider = Provider<double>((ref) {
  final userData = ref.watch(userDataProvider).value;
  if (userData == null || !userData.exists) return 0.0;
  
  return ((userData.data() as Map<String, dynamic>)['savingsBalance'] ?? 0).toDouble();
});

// Daily Usage Provider
final dailyUsageProvider = FutureProvider<int>((ref) async {
  return await UsageService.getDailyUsage();
});

// Weekly Usage Provider
final weeklyUsageProvider = FutureProvider<Map<String, int>>((ref) async {
  return await UsageService.getWeeklyUsage();
});

// App Usage Provider
final appUsageProvider = FutureProvider<List<AppUsage>>((ref) async {
  return await UsageService.getAppUsage();
});

// Blocked Apps Provider
final blockedAppsProvider = FutureProvider<List<String>>((ref) async {
  return await BlockingService.getBlockedApps();
});

// Investments Provider
final investmentsProvider = StreamProvider<QuerySnapshot?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  
  return ref.watch(firebaseServiceProvider).getInvestments(user.uid);
});

// Transactions Provider
final transactionsProvider = StreamProvider<QuerySnapshot?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  
  return ref.watch(firebaseServiceProvider).getTransactions(user.uid);
});

// Permissions Providers
final usageAccessProvider = FutureProvider<bool>((ref) async {
  return await UsageService.hasUsageAccess();
});

final accessibilityProvider = FutureProvider<bool>((ref) async {
  return await BlockingService.hasAccessibilityPermission();
});

