import 'package:hamishphipps/riverpod-version/core/usecase/usecase.dart';
import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../entities/signup_entity.dart';
import '../repo/signup_repo.dart';

// ============================================================================
// [SignupParams] - USE CASE INPUT PARAMETERS
// ============================================================================
// প্যারামিটারগুলোকে একটি অবজেক্টে গ্রুপ করা যাতে ভবিষ্যতে নতুন ফিল্ড (যেমন: phone)
// যুক্ত করতে হলে ফাংশন সিগনেচার ভাঙতে না হয়।
// ============================================================================
class SignupParams {
  final String fullName;
  final String email;
  final String password;

  const SignupParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

// ============================================================================
// [SignupUseCase] - BUSINESS USE CASE
// ============================================================================
// Single Responsibility Principle (SRP):
// এই ক্লাসের একমাত্র দায়িত্ব হলো সাইনআপ রিকোয়েস্টটি ভ্যালিডেশন শেষে রিপোজিটরির
// মাধ্যমে সম্পন্ন করা।
// ============================================================================

class SignupUseCase implements UseCase<Result<SignupEntity>, SignupParams> {
  final SignupRepo repository;

  SignupUseCase(this.repository);

  @override
  Future<Result<SignupEntity>> call(SignupParams params) async {
    return await repository.signup(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}
