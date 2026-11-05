import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/errors/failures.dart';
import 'package:hamishphipps/riverpod-version/core/network/network_info.dart';
import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repo/login_repo.dart';
import '../datasources/login_local_data_source.dart';
import '../datasources/login_remote_data_source.dart';

// ============================================================================
// [LoginRepoImpl] - DATA REPOSITORY IMPLEMENTATION
// ============================================================================
// কেন Repository Implementation Data Layer এ থাকে?
// 
// ১. Domain Layer এ থাকে শুধুমাত্র [LoginRepo] ইন্টারফেস (চুক্তি)। 
//    আর Data Layer সেই ইন্টারফেসটিকে বাস্তবে রূপ দেয়।
// ২. এটি RemoteDataSource, LocalDataSource এবং NetworkInfo এর মধ্যে সমন্বয় করে।
// ৩. সবচেয়ে গুরুত্বপূর্ণ কাজ: এটি কোনো Exception কে Domain বা UI পর্যন্ত যেতে দেয় না।
//    সব Exception ক্যাচ করে সুন্দরভাবে [Failure] এ ম্যাপ করে [Result] রিটার্ন করে।
// ============================================================================

class LoginRepoImpl implements LoginRepo {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LoginRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    // ১. ইন্টারনেট কানেকশন চেক করা
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const Result.failure(NetworkFailure());
    }

    try {
      // ২. রিমোট API থেকে লগইন কল করা
      final loginModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // ৩. টোকেন আসলে তা সরাসরি লোকাল স্টোরেজে সেভ করা
      if (loginModel.token.isNotEmpty) {
        await localDataSource.saveAuthData(
          token: loginModel.token,
          role: loginModel.role,
          email: loginModel.email,
        );
      }

      // ৪. সাকসেস রেজাল্ট রিটার্ন করা
      return Result.success(loginModel);
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

  @override
  Future<Result<void>> saveSession({
    required String token,
    required String role,
    required String email,
  }) async {
    try {
      await localDataSource.saveAuthData(token: token, role: role, email: email);
      return const Result.success(null);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isUserLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      final hasToken = token != null && token.trim().isNotEmpty;
      return Result.success(hasToken);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
