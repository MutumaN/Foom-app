import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class PaymentService {
  // Initiate STK Push for M-Pesa Payment
  Future<PaymentResult> initiateSTKPush({
    required double amount,
    required String phoneNumber,
    required String reason,
  }) async {
    try {
      // Format phone number (remove +254 or 0, add 254)
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      // In production, this would call your backend API
      // which handles M-Pesa Daraja API integration
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/mpesa/stkpush'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount.toInt(),
          'phoneNumber': formattedPhone,
          'accountReference': 'FOOM',
          'transactionDesc': reason,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          message: 'Payment initiated. Please enter M-Pesa PIN.',
          checkoutRequestId: data['CheckoutRequestID'],
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'Payment initiation failed',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  // Check STK Push Status
  Future<PaymentResult> checkSTKPushStatus(String checkoutRequestId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/mpesa/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'checkoutRequestId': checkoutRequestId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultCode = data['ResultCode'];
        
        if (resultCode == '0') {
          return PaymentResult(
            success: true,
            message: 'Payment successful',
          );
        } else {
          return PaymentResult(
            success: false,
            message: data['ResultDesc'] ?? 'Payment failed',
          );
        }
      } else {
        return PaymentResult(
          success: false,
          message: 'Status check failed',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  // Verify M-Pesa Number (sends KES 1)
  Future<PaymentResult> verifyMPesa(String phoneNumber) async {
    return await initiateSTKPush(
      amount: 1.0,
      phoneNumber: phoneNumber,
      reason: 'Account Verification',
    );
  }

  // Withdraw to M-Pesa (B2C)
  Future<PaymentResult> withdrawToMPesa({
    required double amount,
    required String phoneNumber,
  }) async {
    try {
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/mpesa/b2c'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount.toInt(),
          'phoneNumber': formattedPhone,
          'occasion': 'Withdrawal',
        }),
      );

      if (response.statusCode == 200) {
        return PaymentResult(
          success: true,
          message: 'Withdrawal initiated successfully',
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'Withdrawal failed',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  // Format Phone Number for M-Pesa
  String _formatPhoneNumber(String phone) {
    // Remove spaces, dashes, and plus sign
    phone = phone.replaceAll(RegExp(r'[\s\-\+]'), '');
    
    // If starts with 0, replace with 254
    if (phone.startsWith('0')) {
      phone = '254${phone.substring(1)}';
    }
    
    // If starts with 254, keep as is
    if (phone.startsWith('254')) {
      return phone;
    }
    
    // Otherwise, assume it's missing country code
    return '254$phone';
  }
}

class PaymentResult {
  final bool success;
  final String message;
  final String? checkoutRequestId;

  PaymentResult({
    required this.success,
    required this.message,
    this.checkoutRequestId,
  });
}

