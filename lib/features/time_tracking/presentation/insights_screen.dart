import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers.dart';
import '../../../core/widgets/app_card.dart';
import 'widgets/usage_chart.dart';
import 'widgets/usage_list.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyUsageAsync = ref.watch(dailyUsageProvider);
    final weeklyUsageAsync = ref.watch(weeklyUsageProvider);
    final appUsageAsync = ref.watch(appUsageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Insights'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Daily Tab
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dailyUsageProvider);
              ref.invalidate(appUsageProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Summary Card
                  dailyUsageAsync.when(
                    data: (minutes) => AppCard(
                      child: Column(
                        children: [
                          Text(
                            'Today\'s Screen Time',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${(minutes ~/ 60)}h ${minutes % 60}m',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${minutes} minutes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    loading: () => const AppCard(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const AppCard(
                      child: Text('Error loading data'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Per-App Usage
                  Text(
                    'App Usage Today',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  appUsageAsync.when(
                    data: (apps) => UsageList(apps: apps),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Error loading app usage'),
                  ),
                ],
              ),
            ),
          ),

          // Weekly Tab
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(weeklyUsageProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly Chart
                  Text(
                    'Weekly Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  weeklyUsageAsync.when(
                    data: (usage) => UsageChart(weeklyData: usage),
                    loading: () => const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox(
                      height: 300,
                      child: Center(child: Text('Error loading chart')),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weekly Stats
                  Text(
                    'Weekly Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  weeklyUsageAsync.when(
                    data: (usage) {
                      final totalMinutes =
                          usage.values.fold<int>(0, (sum, val) => sum + val);
                      final avgMinutes = totalMinutes ~/ 7;

                      return Column(
                        children: [
                          AppCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      '${totalMinutes ~/ 60}h ${totalMinutes % 60}m',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Average',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      '${avgMinutes ~/ 60}h ${avgMinutes % 60}m',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Error loading stats'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              // Already on insights
              break;
            case 2:
              context.push('/wallet');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


