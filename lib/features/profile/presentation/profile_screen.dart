import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../services/usage_service.dart';
import '../../../services/blocking_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userData = ref.watch(userDataProvider);
    final tokens = ref.watch(tokensProvider);
    final balance = ref.watch(savingsBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                            user?.displayName?.substring(0, 1).toUpperCase() ??
                                'U',
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        context,
                        'Tokens',
                        '$tokens',
                        Icons.token,
                      ),
                      _buildStatItem(
                        context,
                        'Balance',
                        'KES ${balance.toStringAsFixed(0)}',
                        Icons.account_balance_wallet,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to edit profile
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Toggle notifications
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Privacy & Security'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy settings
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Permissions Section
            Text(
              'Permissions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final hasUsageAccess =
                          ref.watch(usageAccessProvider).value ?? false;
                      return ListTile(
                        leading: Icon(
                          Icons.analytics,
                          color: hasUsageAccess ? Colors.green : Colors.red,
                        ),
                        title: const Text('Usage Access'),
                        subtitle: Text(
                          hasUsageAccess ? 'Granted' : 'Not granted',
                        ),
                        trailing: hasUsageAccess
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () async {
                                  // Request permission
                                  await UsageService.requestUsageAccess();
                                  ref.invalidate(usageAccessProvider);
                                },
                                child: const Text('Grant'),
                              ),
                      );
                    },
                  ),
                  const Divider(),
                  Consumer(
                    builder: (context, ref, child) {
                      final hasAccessibility =
                          ref.watch(accessibilityProvider).value ?? false;
                      return ListTile(
                        leading: Icon(
                          Icons.accessibility,
                          color: hasAccessibility ? Colors.green : Colors.red,
                        ),
                        title: const Text('Accessibility Service'),
                        subtitle: Text(
                          hasAccessibility ? 'Enabled' : 'Disabled',
                        ),
                        trailing: hasAccessibility
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () async {
                                  // Request permission
                                  await BlockingService.requestAccessibilityPermission();
                                  ref.invalidate(accessibilityProvider);
                                },
                                child: const Text('Enable'),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sign Out Button
            AppButton(
              text: 'Sign Out',
              onPressed: () async {
                final confirmed = await _showSignOutDialog(context);
                if (confirmed == true) {
                  await ref.read(firebaseServiceProvider).signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
              variant: ButtonVariant.outlined,
            ),
            const SizedBox(height: 16),

            // Delete Account Button
            TextButton(
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.push('/insights');
              break;
            case 2:
              context.push('/wallet');
              break;
            case 3:
              // Already on profile
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<bool?> _showSignOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'FOOM',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 FOOM. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Focus On One Mission\n\n'
          'Track your screen time, earn tokens for reduced usage, '
          'and invest in your future with Money Market Funds.',
        ),
      ],
    );
  }
}

