import 'package:hamishphipps/riverpod-version/core/constants/api_endpoints.dart';
import 'package:hamishphipps/riverpod-version/core/errors/exceptions.dart';
import 'package:hamishphipps/riverpod-version/core/network/api_client.dart';
import '../models/signup_model.dart';

// ============================================================================
// [SignupRemoteDataSource] - DATA LAYER
// ============================================================================
// এই ক্লাসের কাজ ব্যাকএন্ডের রেজিস্ট্রেশন API এর সাথে যোগাযোগ করা।
// ApiClient ব্যবহার করে HTTP POST রিকোয়েস্ট পাঠানো এবং মডেল রিটার্ন করা।
// ============================================================================

abstract class SignupRemoteDataSource {
  Future<SignupModel> signup({
    required String fullName,
    required String email,
    required String password,
  });
}

class SignupRemoteDataSourceImpl implements SignupRemoteDataSource {
  final ApiClient apiClient;

  SignupRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SignupModel> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );

    if (response == null || response is! Map<String, dynamic>) {
      throw const ServerException(message: 'Invalid response from server.');
    }

    return SignupModel.fromJson(
      response,
      fallbackEmail: email,
      fallbackName: fullName,
    );
  }
}
