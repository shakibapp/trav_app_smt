import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/storage/local_storage_service.dart';

// ============================================================================
// [SignupLocalDataSource] - DATA LAYER
// ============================================================================
// প্রয়োজন অনুযায়ী সাইনআপ করা ইউজারের ইমেইল লোকাল স্টোরেজে সংরক্ষণ করে,
// যাতে পরবর্তী OTP ভেরিফিকেশন স্ক্রিনে তা প্রি-ফিল করা যায়।
// ============================================================================

abstract class SignupLocalDataSource {
  Future<void> saveRegisteredEmail(String email);
  Future<String?> getRegisteredEmail();
}

class SignupLocalDataSourceImpl implements SignupLocalDataSource {
  final LocalStorageService storageService;

  SignupLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> saveRegisteredEmail(String email) async {
    try {
      await storageService.saveUserEmail(email);
    } catch (e) {
      throw CacheException(message: 'Failed to cache registered email: $e');
    }
  }

  @override
  Future<String?> getRegisteredEmail() async {
    try {
      return await storageService.getUserEmail();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached email: $e');
    }
  }
}
