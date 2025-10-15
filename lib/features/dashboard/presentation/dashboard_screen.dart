import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers.dart';
import '../../../core/widgets/app_card.dart';
import 'widgets/summary_card.dart';
import 'widgets/quick_action_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final tokens = ref.watch(tokensProvider);
    final balance = ref.watch(savingsBalanceProvider);
    final dailyUsageAsync = ref.watch(dailyUsageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FOOM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              child: Text(
                user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
              ),
            ),
            onPressed: () {
              context.push('/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dailyUsageProvider);
          ref.invalidate(userDataProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Hello, ${user?.displayName ?? "User"}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Let\'s reduce screen time today',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              dailyUsageAsync.when(
                data: (minutes) => SummaryCard(
                  title: 'Screen Time Today',
                  value: '${minutes} min',
                  icon: Icons.access_time,
                  color: Colors.blue,
                ),
                loading: () => const SummaryCard(
                  title: 'Screen Time Today',
                  value: '...',
                  icon: Icons.access_time,
                  color: Colors.blue,
                ),
                error: (_, __) => const SummaryCard(
                  title: 'Screen Time Today',
                  value: 'Error',
                  icon: Icons.access_time,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              SummaryCard(
                title: 'Tokens Earned',
                value: '$tokens',
                icon: Icons.token,
                color: Colors.green,
              ),
              const SizedBox(height: 16),

              SummaryCard(
                title: 'Savings Balance',
                value: 'KES ${balance.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                color: Colors.purple,
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickActionButton(
                    icon: Icons.add_circle,
                    label: 'Buy Tokens',
                    onTap: () => context.push('/token-purchase'),
                  ),
                  QuickActionButton(
                    icon: Icons.trending_up,
                    label: 'Invest',
                    onTap: () => context.push('/invest'),
                  ),
                  QuickActionButton(
                    icon: Icons.block,
                    label: 'Block Apps',
                    onTap: () => context.push('/apps'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              _buildActivityList(ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              context.push('/insights');
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

  Widget _buildActivityList(WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (snapshot) {
        if (snapshot == null || snapshot.docs.isEmpty) {
          return const AppCard(
            child: Text('No recent activity'),
          );
        }

        return Column(
          children: snapshot.docs.take(5).map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                child: Icon(_getActivityIcon(data['type'])),
              ),
              title: Text(data['description'] ?? ''),
              subtitle: Text(data['type'] ?? ''),
              trailing: Text(
                'KES ${data['amount'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const AppCard(
        child: Text('Error loading activity'),
      ),
    );
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdrawal':
        return Icons.arrow_upward;
      case 'investment':
        return Icons.trending_up;
      case 'reward':
        return Icons.card_giftcard;
      default:
        return Icons.monetization_on;
    }
  }
}

