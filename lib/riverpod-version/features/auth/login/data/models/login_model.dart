import '../../domain/entities/login_entity.dart';

/// ============================================================================
/// [LoginModel] - DATA LAYER
/// ============================================================================
/// কেন Model ক্লাস Entity কে extends করে?
/// 
/// ১. Model এর কাজ হলো Raw JSON কে পার্স করে Dart অবজেক্টে রূপান্তর করা।
/// ২. যেহেতু Model নিজেই একটি [LoginEntity], তাই Data Layer থেকে সরাসরি Model
///    রিটার্ন করলেও Domain Layer তাকে Entity হিসেবে গ্রহণ করতে পারে (Liskov Substitution Principle)।
/// ৩. Domain কখনো জানবে না যে এটি কীভাবে JSON থেকে এসেছে, যার ফলে ব্যাকএন্ডে 
///    API কী (Key name) পরিবর্তন হলেও ডোমেইনে কোনো হাত দিতে হয় না।
/// ============================================================================

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.email,
    required super.token,
    required super.role,
    super.isEmailVerified = false,
    super.isProfileComplete = false,
    super.userId,
  });

  /// Factory constructor for parsing API response JSON
  factory LoginModel.fromJson(Map<String, dynamic> json, {String? fallbackEmail}) {
    // API রেসপন্স সরাসরি `data` অবজেক্ট অথবা রুট লেভেলে থাকতে পারে
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final userData = data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : null;

    final resolvedEmail = (data['email'] ??
            userData?['email'] ??
            fallbackEmail ??
            '')
        .toString();

    final resolvedToken = (data['token'] ??
            data['accessToken'] ??
            '')
        .toString();

    final resolvedRole = (data['role'] ??
            userData?['role'] ??
            'USER')
        .toString();

    final resolvedUserId = (data['userId'] ??
            data['id'] ??
            userData?['_id'] ??
            userData?['id'])
        ?.toString();

    final emailVerified = data['emailVerified'] ??
        userData?['emailVerified'] ??
        data['isEmailVerified'] ??
        false;

    final profileComplete = data['isProfileComplete'] ??
        userData?['isProfileComplete'] ??
        false;

    return LoginModel(
      email: resolvedEmail,
      token: resolvedToken,
      role: resolvedRole,
      isEmailVerified: emailVerified is bool ? emailVerified : false,
      isProfileComplete: profileComplete is bool ? profileComplete : false,
      userId: resolvedUserId,
    );
  }

  /// Convert Model to JSON (e.g. for caching / local storage)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'isProfileComplete': isProfileComplete,
      'userId': userId,
    };
  }
}

