import 'package:hamishphipps/riverpod-version/core/constants/api_endpoints.dart';
import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/network/api_client.dart';
import '../models/login_model.dart';

// ============================================================================
// [LoginRemoteDataSource] - DATA LAYER
// ============================================================================
// এই ক্লাসের কাজ শুধু রিমোট সার্ভার (API) এর সাথে যোগাযোগ করা।
// এটি কোনো বিজনেস লজিক হ্যান্ডেল করে না, কেবল নেটওয়ার্ক রিকোয়েস্ট পাঠায় এবং
// মডেল রিটার্ন করে অথবা [ServerException] থ্রো করে।
// ============================================================================

abstract class LoginRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
  });
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response == null || response is! Map<String, dynamic>) {
      throw const ServerException(
          message: 'Invalid response received from server.');
    }

    return LoginModel.fromJson(response, fallbackEmail: email);
  }
}
