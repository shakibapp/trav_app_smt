// ============================================================================
// [UseCase] - BASE CONTRACT FOR ALL USE CASES
// ============================================================================
// কেন UseCase প্যাটার্ন?
// ১. Single Responsibility Principle (SRP): প্রতিটি UseCase শুধুমাত্র একটি নির্দিষ্ট
//    বিজনেস লজিক বা অ্যাকশন হ্যান্ডেল করে (যেমন: LoginUseCase, LogoutUseCase)।
// ২. Callable Class: Dart এর `call()` মেথডের কারণে UseCase অবজেক্টকে সরাসরি
//    ফাংশনের মতো কল করা যায়: `await loginUseCase(params)`.
// ============================================================================

abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// যে UseCase এ কোনো প্যারামিটার দরকার হয় না তার জন্য:
class NoParams {
  const NoParams();
}
