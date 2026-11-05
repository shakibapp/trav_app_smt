// ============================================================================
// [SignupEntity] - DOMAIN LAYER (PURE DART)
// ============================================================================
// Clean Architecture এর নিয়ম অনুযায়ী Entity একটি Pure Dart ক্লাস।
// এখানে কোনো:
// - JSON Serialization (fromJson / toJson)
// - Flutter UI প্যাকেজ
// - থার্ড-পার্টি লাইব্রেরি থাকবে না।
// 
// উদ্দেশ্য: রেজিস্ট্রেশন সংক্রান্ত পিওর বিজনেস ডাটা ধারণ করা।
// ============================================================================

class SignupEntity {
  final String email;
  final String fullName;
  final String? userId;
  final bool isEmailVerified;
  final String? message;

  const SignupEntity({
    required this.email,
    required this.fullName,
    this.userId,
    this.isEmailVerified = false,
    this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupEntity &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          fullName == other.fullName;

  @override
  int get hashCode => email.hashCode ^ fullName.hashCode;
}
