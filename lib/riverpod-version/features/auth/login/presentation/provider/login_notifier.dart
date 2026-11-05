import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamishphipps/riverpod-version/core/network/api_client.dart';
import 'package:hamishphipps/riverpod-version/core/network/network_info.dart';
import 'package:hamishphipps/riverpod-version/core/storage/local_storage_service.dart';
import '../../data/datasources/login_local_data_source.dart';
import '../../data/datasources/login_remote_data_source.dart';
import '../../data/repo/login_repo_impl.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repo/login_repo.dart';
import '../../domain/usecases/login_use_case.dart';

// ============================================================================
// [LoginState] - PRESENTATION LAYER IMMUTABLE STATE
// ============================================================================
// কেন আলাদা State ক্লাস?
//
// ১. Immutability: স্টেট কখনো সরাসরি মিউটেট (পরিবর্তন) করা হয় না।
//    বরং copyWith মেথডের মাধ্যমে নতুন স্টেট তৈরি করা হয়। এতে রি-রেন্ডারিং নিখুঁত থাকে।
// ২. Loading, Success, Error এবং ফর্ম ভিউ স্টেট (যেমন: পাসওয়ার্ড হাইড/শো)
//    এক জায়গায় প্রিডিক্টেবল ভাবে ট্র্যাকিং হয়।
// ============================================================================

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final LoginEntity? userSession;
  final bool isPasswordVisible;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.userSession,
    this.isPasswordVisible = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
    LoginEntity? userSession,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      userSession: userSession ?? this.userSession,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

// ============================================================================
// [LoginNotifier] - RIVERPOD STATE NOTIFIER
// ============================================================================
// GetX Controller এর বিকল্প হিসেবে Riverpod এ StateNotifier সবচেয়ে জনপ্রিয় ও স্থায়ী সমাধান।
//
// বৈশিষ্ট্য:
// ১. Notifier শুধুমাত্র Domain UseCase এর উপর নির্ভর করে, কোনো Data Layer চেনে না।
// ২. UI তে বিজনেস লজিক থাকে না; সব লজিক এই Notifier এর মেথডে হ্যান্ডেল হয়।
// ============================================================================

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginNotifier(this._loginUseCase) : super(const LoginState());

  /// পাসওয়ার্ড ফিল্ডের চোখের আইকন টগল করার মেথড
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// এরর মেসেজ ক্লিয়ার করার মেথড
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  /// লগইন সাবমিট করার মেথড
  Future<void> submitLogin({
    required String email,
    required String password,
  }) async {
    // লোডিং শুরু এবং আগের এরর ক্লিয়ার করা
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isSuccess: false,
    );

    // UseCase কল করা
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    // সাকসেস বা এরর অনুযায়ী স্টেট আপডেট
    result.when(
      success: (entity) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userSession: entity,
        );
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
    );
  }
}

// ============================================================================
// DEPENDENCY INJECTION (DI) VIA RIVERPOD PROVIDERS
// ============================================================================
// Get.put(...) বা সার্ভিস লোকেটরের বদলে Riverpod এর নিজস্ব Provider চেইন
// ব্যবহার করা হয়। এতে কোনো মেমোরি লিক হয় না এবং উইজেট ট্রির সাথে নিখুঁতভাবে ডিসপোজ হয়।
// ============================================================================

/// ১. Remote Data Source Provider
final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LoginRemoteDataSourceImpl(apiClient: apiClient);
});

/// ২. Local Data Source Provider
final loginLocalDataSourceProvider = Provider<LoginLocalDataSource>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LoginLocalDataSourceImpl(storageService: storageService);
});

/// ৩. Repository Provider (Remote + Local + Network Info যুক্ত করা)
final loginRepoProvider = Provider<LoginRepo>((ref) {
  final remote = ref.watch(loginRemoteDataSourceProvider);
  final local = ref.watch(loginLocalDataSourceProvider);
  final network = ref.watch(networkInfoProvider);
  return LoginRepoImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: network,
  );
});

/// ৪. UseCase Provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(loginRepoProvider);
  return LoginUseCase(repo);
});

/// ৫. Main UI Notifier Provider
final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final useCase = ref.watch(loginUseCaseProvider);
  return LoginNotifier(useCase);
});
