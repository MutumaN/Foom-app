import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';
import '../../../services/blocking_service.dart';

class AppsScreen extends ConsumerStatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends ConsumerState<AppsScreen> {
  final Set<String> _blockedApps = {};

  @override
  void initState() {
    super.initState();
    _loadBlockedApps();
  }

  Future<void> _loadBlockedApps() async {
    final blocked = await BlockingService.getBlockedApps();
    setState(() {
      _blockedApps.addAll(blocked);
    });
  }

  Future<void> _toggleBlock(String packageName, bool block) async {
    if (block) {
      await BlockingService.blockApp(packageName);
      setState(() => _blockedApps.add(packageName));
    } else {
      await BlockingService.unblockApp(packageName);
      setState(() => _blockedApps.remove(packageName));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUsageAsync = ref.watch(appUsageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Apps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      body: appUsageAsync.when(
        data: (apps) {
          if (apps.isEmpty) {
            return const Center(
              child: Text('No apps found'),
            );
          }

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              final isBlocked = _blockedApps.contains(app.packageName);

              return SwitchListTile(
                secondary: const Icon(Icons.android),
                title: Text(app.appName),
                subtitle: Text('Daily usage: ${app.usageMinutes} min'),
                value: isBlocked,
                onChanged: (value) {
                  _toggleBlock(app.packageName, value);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

