import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/constants.dart';
import '../../../providers.dart';
import '../../../services/usage_service.dart';
import '../../../services/blocking_service.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  int _currentStep = 0;
  final _phoneController = TextEditingController();
  String? _selectedMMF;
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    // Request Usage Access
    await UsageService.requestUsageAccess();
    
    // Request Accessibility
    await BlockingService.requestAccessibilityPermission();
    
    setState(() {});
  }

  Future<void> _completeSetup() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final firebaseService = ref.read(firebaseServiceProvider);
    
    await firebaseService.updateUserData(user.uid, {
      'phoneNumber': _phoneController.text.trim(),
      'selectedMMF': _selectedMMF,
      'savingsGoal': double.tryParse(_goalController.text) ?? 0,
      'setupCompleted': true,
    });

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _completeSetup();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('M-Pesa Number'),
            content: Column(
              children: [
                const Text(
                  'Enter your M-Pesa number for deposits and withdrawals',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'M-Pesa Number',
                  hint: '254712345678',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),
              ],
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Select MMF'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose your default Money Market Fund'),
                const SizedBox(height: 16),
                ...AppConstants.mmfOptions.map((mmf) {
                  return RadioListTile<String>(
                    title: Text(mmf['name'] as String),
                    subtitle: Text('Returns: ${mmf['returns']}'),
                    value: mmf['id'] as String,
                    groupValue: _selectedMMF,
                    onChanged: (value) {
                      setState(() => _selectedMMF = value);
                    },
                  );
                }).toList(),
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Savings Goal (Optional)'),
            content: Column(
              children: [
                const Text(
                  'Set a monthly savings goal to help you stay on track',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Monthly Goal',
                  hint: '5000',
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Permissions Required',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Grant Permissions',
                  onPressed: _requestPermissions,
                  icon: Icons.security,
                ),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}

