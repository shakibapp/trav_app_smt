// ============================================================================
// [Failures] - DOMAIN & PRESENTATION LAYER
// ============================================================================
// Clean Architecture এর নিয়ম অনুযায়ী, UI এবং Domain কখনো Exception দিয়ে ক্র্যাশ
// হওয়া উচিত না। Repository সব Exception হ্যান্ডেল করে এই Failure ক্লাসে ম্যাপ করে।
//
// সুবিধা:
// ১. UI খুব সহজে failure.message দিয়ে ইউজার ফ্রেন্ডলি মেসেজ দেখাতে পারে।
// ২. টাইপ অনুযায়ী আলাদা এরর হ্যান্ডলিং (যেমন: NetworkFailure হলে অফলাইন ডায়ালগ)।
// ============================================================================

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// সার্ভার সাইড এরর (যেমন: 400, 404, 500 রেসপন্স)
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

/// ইন্টারনেট কানেকশন না থাকলে
class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message = 'Please check your internet connection.']);
}

/// ভুল পাসওয়ার্ড বা ক্রেডেনশিয়াল দিলে
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// ক্যাশ বা লোকাল ডাটাবেজ ফেইল করলে
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage failure.']);
}

/// ইউজার ইনপুট ভ্যালিডেশন ফেইল করলে
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// অপ্রত্যাশিত কোনো সমস্যা হলে
class UnknownFailure extends Failure {
  const UnknownFailure(
      [super.message = 'An unexpected error occurred. Please try again.']);
}
