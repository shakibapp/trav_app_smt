import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  LocalService._();

  static final LocalService localService = LocalService._();

  static late SharedPreferences _prefs;

  /// Call once in main() before runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Keys ────────────────────────────────────────────────────────────────────
  static const _keyEmail = 'user_email';
  static const _keyPassword = 'user_password';
  static const _keyPhoneNumber = 'user_phone';
  static const _keyCountry = 'user_country';
  static const _keyRole = 'role';
  static const _keyName = 'user_name';
  static const _keyImagePath = 'user_image_path';
  static const _keyToken = 'token';
  static const _paymentToken = 'payment_token';
  static const _userId = 'userId';
  static const _planStatus = 'status';
  static const _userAction = 'actions';
  static const _onBoarding = 'onBoarding';
  static const _schoolId = 'school_id';

  // ── Setters ────────────────────────────────────────────────────────────────
  Future<void> setUserId(String v) => _prefs.setString(_userId, v);

  Future<void> setOnboarding(bool v) => _prefs.setBool(_onBoarding, v);

  Future<void> setPlanStatus(String v) => _prefs.setString(_planStatus, v);

  Future<void> setUserAction(String v) => _prefs.setString(_userAction, v);

  Future<void> setPaymentKey(String v) => _prefs.setString(_paymentToken, v);

  Future<void> setSchoolId(String v) => _prefs.setString(_schoolId, v);

  Future<void> setEmail(String v) => _prefs.setString(_keyEmail, v);

  Future<void> setToken(String v) => _prefs.setString(_keyToken, v);

  Future<void> setPassword(String v) => _prefs.setString(_keyPassword, v);

  Future<void> setPhoneNumber(String v) => _prefs.setString(_keyPhoneNumber, v);

  Future<void> setCountry(String v) => _prefs.setString(_keyCountry, v);

  Future<void> setRole(String v) => _prefs.setString(_keyRole, v);

  Future<void> setName(String v) => _prefs.setString(_keyName, v);

  Future<void> setUID(String v) => _prefs.setString(_userId, v);

  Future<void> setImagePath(String v) => _prefs.setString(_keyImagePath, v);

  // ── Getters (synchronous now) ──────────────────────────────────────────────
  String? getUserId() => _prefs.getString(_userId);

  bool? getOnboarding() => _prefs.getBool(_onBoarding);

  String? getPlanStatus() => _prefs.getString(_planStatus);

  String? getUserAction() => _prefs.getString(_userAction);

  String? getPaymentToken() => _prefs.getString(_paymentToken);

  String? getSelectedSchoolId() => _prefs.getString(_schoolId);

  String? getEmail() => _prefs.getString(_keyEmail);

  String? getToken() => _prefs.getString(_keyToken);

  String? getPhoneNumber() => _prefs.getString(_keyPhoneNumber);

  String? getRole() => _prefs.getString(_keyRole);

  String? getName() => _prefs.getString(_keyName);

  String? getUID() => _prefs.getString(_userId);

  String? getImagePath() => _prefs.getString(_keyImagePath);

  // ── Utilities ──────────────────────────────────────────────────────────────
  Future<void> clearUserData() async {
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyPassword);
    await _prefs.remove(_keyPhoneNumber);
    await _prefs.remove(_keyCountry);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyImagePath);
    await _prefs.remove(_keyToken);
    await _prefs.remove(_paymentToken);
    await _prefs.remove(_userId);
    await _prefs.remove(_schoolId);
  }
}
