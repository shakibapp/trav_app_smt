import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../entities/login_entity.dart';

// ============================================================================
// [LoginRepo] - DOMAIN REPOSITORY CONTRACT (INTERFACE)
// ============================================================================
// কেন এই ইন্টারফেসটি Domain Layer এ রাখা হয়েছে?
//
// Dependency Inversion Principle (DIP):
// হাই লেভেল মডিউল (Domain/UseCase) কখনো লো-লেভেল মডিউলের (Data Layer/API) উপর
// নির্ভর করবে না। দুটোই অ্যাবস্ট্রাকশনের (Interface) উপর নির্ভর করবে।
//
// এখানে আমরা ডোমেইন থেকে বলে দিচ্ছি:
// "লগইন করতে হলে ইমেইল আর পাসওয়ার্ড দিতে হবে এবং আউটপুট হিসেবে Result<LoginEntity> পাওয়া যাবে।"
// ডাটাবেজ থেকে আনবে নাকি নেটওয়ার্ক API থেকে আনবে—তা Domain এর জানার প্রয়োজন নেই।
// ============================================================================

abstract class LoginRepo {
  /// ইমেইল এবং পাসওয়ার্ড দিয়ে লগইন রিকোয়েস্ট পাঠানো
  Future<Result<LoginEntity>> login({
    required String email,
    required String password,
  });

  /// লগইন সাকসেস হলে টোকেন ও রোল লোকালি সেভ করা
  Future<Result<void>> saveSession({
    required String token,
    required String role,
    required String email,
  });

  /// ইউজার ইতিমধ্যে লগইন করা আছে কিনা চেক করা
  Future<Result<bool>> isUserLoggedIn();
}
