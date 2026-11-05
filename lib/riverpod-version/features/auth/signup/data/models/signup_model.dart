import '../../domain/entities/signup_entity.dart';

// ============================================================================
// [SignupModel] - DATA LAYER
// ============================================================================
// কেন Model ক্লাস Entity কে extends করে?
// ১. এটি ব্যাকএন্ডের API রেসপন্স (JSON) পার্স করে Dart অবজেক্ট তৈরি করে।
// ২. যেহেতু Model নিজেই [SignupEntity] এর চাইল্ড, তাই Domain Layer এ সরাসরি এটি
//    রিটার্ন করা যায় (Liskov Substitution Principle)।
// ============================================================================

class SignupModel extends SignupEntity {
  const SignupModel({
    required super.email,
    required super.fullName,
    super.userId,
    super.isEmailVerified = false,
    super.message,
  });

  /// Factory constructor to parse API response JSON
  factory SignupModel.fromJson(Map<String, dynamic> json,
      {String? fallbackEmail, String? fallbackName}) {
    final data =
        json.containsKey('data') && json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    final resolvedEmail =
        (data['email'] ?? data['userEmail'] ?? fallbackEmail ?? '').toString();

    final resolvedName =
        (data['fullName'] ?? data['name'] ?? fallbackName ?? '').toString();

    final resolvedId =
        (data['id'] ?? data['_id'] ?? data['userId'])?.toString();

    final emailVerified =
        data['emailVerified'] ?? data['isEmailVerified'] ?? false;

    final serverMessage = json['message']?.toString();

    return SignupModel(
      email: resolvedEmail,
      fullName: resolvedName,
      userId: resolvedId,
      isEmailVerified: emailVerified is bool ? emailVerified : false,
      message: serverMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'userId': userId,
      'isEmailVerified': isEmailVerified,
      'message': message,
    };
  }
}
