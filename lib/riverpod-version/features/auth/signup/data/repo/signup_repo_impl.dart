import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/errors/failures.dart';
import 'package:hamishphipps/riverpod-version/core/network/network_info.dart';
import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/repo/signup_repo.dart';
import '../datasources/signup_local_data_source.dart';
import '../datasources/signup_remote_data_source.dart';

// ============================================================================
// [SignupRepoImpl] - DATA REPOSITORY IMPLEMENTATION
// ============================================================================
// এটি Domain Layer এর [SignupRepo] ইন্টারফেসকে বাস্তবায়ন করে।
// রিমোট API ও লোকাল ক্যাশ এর মধ্যে সমন্বয় করে এবং সমস্ত এক্সেপশন ক্যাচ করে
// Failure হিসেবে Result এ র‍্যাপ করে পাঠায়।
// ============================================================================

class SignupRepoImpl implements SignupRepo {
  final SignupRemoteDataSource remoteDataSource;
  final SignupLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SignupRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<SignupEntity>> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // ১. ইন্টারনেট কানেক্টিভিটি চেক
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const Result.failure(NetworkFailure());
    }

    try {
      // ২. রিমোট ডাটা সোর্স কল করা
      final signupModel = await remoteDataSource.signup(
        fullName: fullName,
        email: email,
        password: password,
      );

      // ৩. সফল হলে ইমেইলটি লোকালি ক্যাশ করা (OTP স্ক্রিনের সুবিধার জন্য)
      await localDataSource.saveRegisteredEmail(email);

      // ৪. সাকসেস রিটার্ন
      return Result.success(signupModel);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
