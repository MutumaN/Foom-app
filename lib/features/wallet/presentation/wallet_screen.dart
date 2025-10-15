import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(tokensProvider);
    final balance = ref.watch(savingsBalanceProvider);
    final investmentsAsync = ref.watch(investmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            AppCard(
              child: Column(
                children: [
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KES ${balance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Deposit',
                          onPressed: () {
                            // Show deposit dialog
                          },
                          icon: Icons.arrow_downward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Withdraw',
                          onPressed: () {
                            // Show withdraw dialog
                          },
                          isOutlined: true,
                          icon: Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tokens Card
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.token, size: 48, color: Colors.amber),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Tokens',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '$tokens',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    text: 'Use Tokens',
                    onPressed: () {
                      // Navigate to invest
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Investments
            Text(
              'My Investments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            investmentsAsync.when(
              data: (snapshot) {
                if (snapshot == null || snapshot.docs.isEmpty) {
                  return const AppCard(
                    child: Text('No investments yet'),
                  );
                }

                return Column(
                  children: snapshot.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.trending_up),
                      title: Text(data['mmf'] ?? ''),
                      subtitle: Text('Amount: KES ${data['amount']}'),
                      trailing: Chip(label: Text(data['status'] ?? '')),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const AppCard(
                child: Text('Error loading investments'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

