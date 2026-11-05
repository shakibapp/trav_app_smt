// ============================================================================
// [ApiEndpoints] - Centralized API URLs
// ============================================================================
// প্রজেক্টের সব API URL এক জায়গায় রাখার ফলে কখনো সার্ভার ডোমেইন বা পাথ
// চেঞ্জ হলে শুধু এই ফাইল পরিবর্তন করলেই পুরো প্রোজেক্ট আপডেট হয়ে যায়।
// ============================================================================

class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.209.38.85.90.nip.io/api/v1';

  // ------------------ Auth ------------------ //
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/users';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String profile = '$baseUrl/auth/profile';
  static const String logout = '$baseUrl/auth/logout';
}
