// ============================================================================
// [LoginEntity] - DOMAIN LAYER (PURE DART)
// ============================================================================
// ক্লিন আর্কিটেকচারের সবচেয়ে গুরুত্বপূর্ণ নিয়ম:
// Entity সম্পূর্ণ "Pure Dart" ক্লাস হবে। এখানে কোনো:
// - JSON Parsing (fromJson / toJson) থাকবে না
// - থার্ড পার্টি লাইব্রেরি (যেমন: Dio, Http, SharedPreferences) থাকবে না
// - Flutter UI ফ্রেমওয়ার্কের কোনো উইজেট থাকবে না
// 
// কেন?
// যাতে বিজনেস লজিক এবং ডোমেইন ডাটা যেকোনো প্ল্যাটফর্ম বা ফ্রেমওয়ার্ক থেকে
// সম্পূর্ণ স্বাধীন থাকে এবং ব্যাকএন্ডের ফিল্ড নাম চেঞ্জ হলেও ডোমেইন অবিকৃত থাকে।
// ============================================================================

class LoginEntity {
  final String email;
  final String token;
  final String role;
  final bool isEmailVerified;
  final bool isProfileComplete;
  final String? userId;

  const LoginEntity({
    required this.email,
    required this.token,
    required this.role,
    this.isEmailVerified = false,
    this.isProfileComplete = false,
    this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginEntity &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          token == other.token &&
          role == other.role;

  @override
  int get hashCode => email.hashCode ^ token.hashCode ^ role.hashCode;
}
