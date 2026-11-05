// ============================================================================
// [Exceptions] - DATA LAYER
// ============================================================================
// Clean Architecture এ Data Layer (Remote API বা Local DB) থেকে কোনো এরর ঘটলে
// এই কাস্টম Exception গুলো throw করা হয়।
// এগুলো সরাসরি UI তে যায় না, Repository Implementation এগুলোকে ক্যাচ করে
// সংশ্লিষ্ট [Failure] অবজেক্টে কনভার্ট করে।
// ============================================================================

/// সার্ভার থেকে কোনো নন-২০০ রেসপন্স বা API এরর আসলে এই এক্সেপশন হয়
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message)';
}

/// ইন্টারনেট কানেকশন না থাকলে এই এক্সেপশন থ্রো হয়
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No internet connection available.'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// অথেনটিকেশন বা টোকেন সংক্রান্ত সমস্যা (যেমন: 401 Unauthorized)
class AuthException implements Exception {
  final String message;

  const AuthException(
      {this.message = 'Authentication failed. Please login again.'});

  @override
  String toString() => 'AuthException(message: $message)';
}

/// লোকাল স্টোরেজ (SharedPreferences / Cache) পড়ার বা লেখার সময় সমস্যা হলে
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache error occurred.'});

  @override
  String toString() => 'CacheException(message: $message)';
}
