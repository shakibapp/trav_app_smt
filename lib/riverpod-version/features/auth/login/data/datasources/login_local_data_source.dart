import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/storage/local_storage_service.dart';

// ============================================================================
// [LoginLocalDataSource] - DATA LAYER
// ============================================================================
// এই ক্লাসের কাজ হলো লগইন সেশনের ডেটা (Auth Token, User Role ইত্যাদি)
// ডিভাইসের লোকাল স্টোরেজে (SharedPreferences) ক্যাশ বা পারসিস্ট করা।
// ============================================================================

abstract class LoginLocalDataSource {
  Future<void> saveAuthData({
    required String token,
    required String role,
    required String email,
  });

  Future<String?> getToken();
  Future<String?> getRole();
  Future<void> clearAuthData();
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final LocalStorageService storageService;

  LoginLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> saveAuthData({
    required String token,
    required String role,
    required String email,
  }) async {
    try {
      await storageService.saveToken(token);
      await storageService.saveRole(role);
      await storageService.saveUserEmail(email);
    } catch (e) {
      throw CacheException(message: 'Failed to save login session locally: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await storageService.getToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get token from cache: $e');
    }
  }

  @override
  Future<String?> getRole() async {
    try {
      return await storageService.getRole();
    } catch (e) {
      throw CacheException(message: 'Failed to get role from cache: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await storageService.clearAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth cache: $e');
    }
  }
}
