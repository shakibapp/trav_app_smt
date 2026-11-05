import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../entities/signup_entity.dart';

// ============================================================================
// [SignupRepo] - DOMAIN REPOSITORY CONTRACT (INTERFACE)
// ============================================================================
// Dependency Inversion Principle (DIP):
// Domain Layer শুধু ঘোষণা করে যে সাইনআপ করার জন্য কী কী ডাটা প্রয়োজন
// এবং কী ফলাফল পাওয়া যাবে। API কল কিভাবে হবে তা Data Layer এর দায়িত্ব।
// ============================================================================

abstract class SignupRepo {
  /// নতুন ইউজার অ্যাকাউন্ট তৈরির মেথড
  Future<Result<SignupEntity>> signup({
    required String fullName,
    required String email,
    required String password,
  });
}
