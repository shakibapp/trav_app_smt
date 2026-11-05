import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// [LocalStorageService] - LOCAL STORAGE CONTRACT & IMPLEMENTATION
/// ============================================================================
/// কেন SharedPreferences সরাসরি ব্যবহার না করে ইন্টারফেস ব্যবহার করা হয়েছে?
/// ১. ইন ফিউচারে যদি Encrypted SharedPreferences / FlutterSecureStorage বা Hive এ
///    মাইগ্রেট করতে চান, তবে শুধু এই ইমপ্লিমেন্টেশন পরিবর্তন করলেই হবে,
///    প্রজেক্টের কোনো ফিচারের কোড হাত দেওয়া লাগবে না (Open-Closed Principle)।
/// ২. ইউনিট টেস্টের সময় মক করা সহজ।
/// ============================================================================

abstract class LocalStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveRole(String role);
  Future<String?> getRole();
  Future<void> saveUserEmail(String email);
  Future<String?> getUserEmail();
  Future<void> clearAll();
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageServiceImpl(this.prefs);

  static const String _keyToken = 'auth_token';
  static const String _keyRole = 'user_role';
  static const String _keyEmail = 'user_email';

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_keyToken, token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(_keyToken);
  }

  @override
  Future<void> saveRole(String role) async {
    await prefs.setString(_keyRole, role);
  }

  @override
  Future<String?> getRole() async {
    return prefs.getString(_keyRole);
  }

  @override
  Future<void> saveUserEmail(String email) async {
    await prefs.setString(_keyEmail, email);
  }

  @override
  Future<String?> getUserEmail() async {
    return prefs.getString(_keyEmail);
  }

  @override
  Future<void> clearAll() async {
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyEmail);
  }
}

/// SharedPreferences instance provider (main এ ওভাররাইড বা async ইনিশিয়ালাইজ করা যায়)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main.dart');
});

/// LocalStorageService Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageServiceImpl(prefs);
});

