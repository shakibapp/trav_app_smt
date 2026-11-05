import 'package:hamishphipps/riverpod-version/core/usecase/usecase.dart';
import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../entities/login_entity.dart';
import '../repo/login_repo.dart';

// ============================================================================
// [LoginParams] - USE CASE INPUT PARAMETERS
// ============================================================================
// কেন আলাদা Params ক্লাস?
// ইউজারের ইনপুট ভ্যালুগুলোকে একটি অবজেক্টে গ্রুপ করা হয়। ভবিষ্যতে যদি আরও 
// প্যারামিটার যুক্ত হয় (যেমন: deviceId বা rememberMe), তবে ফাংশন সিগনেচার না ভেঙে
// সহজেই প্যারামিটার পাস করা যায়।
// ============================================================================
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

// ============================================================================
// [LoginUseCase] - BUSINESS USE CASE
// ============================================================================
// Single Responsibility Principle (SRP):
// প্রতিটি UseCase শুধুমাত্র একটি নির্দিষ্ট বিজনেস লজিক হ্যান্ডেল করে।
// এখানে LoginUseCase এর একমাত্র দায়িত্ব হলো লগইন প্রক্রিয়া এক্সিকিউট করা।
// 
// Dart এর `call` মেথড ব্যবহারের ফলে UseCase কে সরাসরি ফাংশনের মতো কল করা যায়:
// ```dart
// final result = await loginUseCase(LoginParams(email: '...', password: '...'));
// ```
// ============================================================================

class LoginUseCase implements UseCase<Result<LoginEntity>, LoginParams> {
  final LoginRepo repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<LoginEntity>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
