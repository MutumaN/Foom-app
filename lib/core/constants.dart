class AppConstants {
  // App Info
  static const String appName = 'FOOM';
  static const String appTagline = 'Focus On One Mission';
  static const String appVersion = '1.0.0';

  // API URLs (Replace with your actual URLs)
  static const String baseUrl = 'https://api.foom.app';
  static const String mpesaCallbackUrl = 'https://api.foom.app/mpesa/callback';

  // M-Pesa Credentials (Replace with actual credentials)
  static const String mpesaConsumerKey = 'YOUR_CONSUMER_KEY';
  static const String mpesaConsumerSecret = 'YOUR_CONSUMER_SECRET';
  static const String mpesaShortcode = 'YOUR_SHORTCODE';
  static const String mpesaPasskey = 'YOUR_PASSKEY';

  // Token Economics
  static const int minutesPerToken = 10; // 10 minutes reduced = 1 token
  static const double tokenToKesRate = 1.0; // 1 token = 1 KES

  // MMF Options
  static const List<Map<String, dynamic>> mmfOptions = [
    {
      'id': 'cic',
      'name': 'CIC Money Market Fund',
      'returns': '10-12% p.a.',
      'minInvestment': 1000,
    },
    {
      'id': 'sanlam',
      'name': 'Sanlam Money Market Fund',
      'returns': '9-11% p.a.',
      'minInvestment': 500,
    },
    {
      'id': 'britam',
      'name': 'Britam Money Market Fund',
      'returns': '9-10% p.a.',
      'minInvestment': 1000,
    },
  ];

  // Permissions
  static const String usageStatsPermission = 'android.permission.PACKAGE_USAGE_STATS';
  static const String accessibilityPermission = 'android.permission.BIND_ACCESSIBILITY_SERVICE';
}

class AppStrings {
  // Onboarding
  static const String onboarding1Title = 'Track Your Screen Time';
  static const String onboarding1Desc = 'Monitor how much time you spend on your phone and apps daily.';
  
  static const String onboarding2Title = 'Earn Tokens for Less Usage';
  static const String onboarding2Desc = 'Reduce your screen time and earn tokens as rewards!';
  
  static const String onboarding3Title = 'Invest & Grow Your Savings';
  static const String onboarding3Desc = 'Use your tokens to invest in Money Market Funds and earn returns.';
  
  static const String onboarding4Title = 'Link M-Pesa for Easy Deposits';
  static const String onboarding4Desc = 'Seamlessly deposit and withdraw using M-Pesa.';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorAuth = 'Authentication failed. Please try again.';
  static const String errorPayment = 'Payment failed. Please try again.';

  // Success
  static const String successLogin = 'Welcome back!';
  static const String successSignup = 'Account created successfully!';
  static const String successInvestment = 'Investment successful!';
  static const String successDeposit = 'Deposit successful!';
}

