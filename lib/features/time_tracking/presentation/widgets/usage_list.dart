import 'package:flutter/material.dart';
import '../../../../services/usage_service.dart';
import '../../../../core/widgets/app_card.dart';

class UsageList extends StatelessWidget {
  final List<AppUsage> apps;

  const UsageList({Key? key, required this.apps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return const AppCard(
        child: Center(
          child: Text('No app usage data available'),
        ),
      );
    }

    // Sort apps by usage time
    final sortedApps = List<AppUsage>.from(apps)
      ..sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));

    return Column(
      children: sortedApps.map((app) {
        return AppCard(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.apps,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              app.appName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(app.packageName),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${app.usageMinutes ~/ 60}h ${app.usageMinutes % 60}m',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${app.usageMinutes} min',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


