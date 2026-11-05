import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamishphipps/riverpod-version/core/network/api_client.dart';
import 'package:hamishphipps/riverpod-version/core/network/network_info.dart';
import 'package:hamishphipps/riverpod-version/core/storage/local_storage_service.dart';
import '../../data/datasources/signup_local_data_source.dart';
import '../../data/datasources/signup_remote_data_source.dart';
import '../../data/repo/signup_repo_impl.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/repo/signup_repo.dart';
import '../../domain/usecases/signup_use_case.dart';

// ============================================================================
// [SignupState] - IMMUTABLE UI STATE
// ============================================================================
// লোডিং স্টেট, এরর মেসেজ, সফলতার স্টেট এবং ফর্মের ফিল্ড অপশনগুলো
// এই ইমিউটেবল স্টেটে সংরক্ষিত থাকে।
// ============================================================================

class SignupState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final SignupEntity? successData;
  final bool isPasswordVisible;
  final bool isTermsAgreed;

  const SignupState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.successData,
    this.isPasswordVisible = false,
    this.isTermsAgreed = false,
  });

  SignupState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
    SignupEntity? successData,
    bool? isPasswordVisible,
    bool? isTermsAgreed,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      successData: successData ?? this.successData,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAgreed: isTermsAgreed ?? this.isTermsAgreed,
    );
  }
}

// ============================================================================
// [SignupNotifier] - STATE NOTIFIER
// ============================================================================
// সমস্ত প্রেজেন্টেশন লজিক এই Notifier এ থাকে।
// এটি শুধুমাত্র UseCase এর সাথে কথা বলে, কোনো ডেটা সোর্স বা API চেনে না।
// ============================================================================

class SignupNotifier extends StateNotifier<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupNotifier(this._signupUseCase) : super(const SignupState());

  /// পাসওয়ার্ড দেখা/লুকানোর টগল
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// শর্তাবলি (Terms & Conditions) চেকবক্স টগল
  void toggleTermsAgreement() {
    state = state.copyWith(isTermsAgreed: !state.isTermsAgreed);
  }

  /// এরর মেসেজ ক্লিয়ার
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  /// সাইনআপ সাবমিট
  Future<void> submitSignup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // শর্তাবলি মেনে নিয়েছে কিনা যাচাই
    if (!state.isTermsAgreed) {
      state = state.copyWith(
        errorMessage: 'You must agree to the terms and conditions.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isSuccess: false,
    );

    final result = await _signupUseCase(
      SignupParams(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );

    result.when(
      success: (entity) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          successData: entity,
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
// RIVERPOD DEPENDENCY INJECTION PROVIDERS
// ============================================================================

/// Remote Data Source Provider
final signupRemoteDataSourceProvider = Provider<SignupRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SignupRemoteDataSourceImpl(apiClient: apiClient);
});

/// Local Data Source Provider
final signupLocalDataSourceProvider = Provider<SignupLocalDataSource>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return SignupLocalDataSourceImpl(storageService: storageService);
});

/// Repository Provider
final signupRepoProvider = Provider<SignupRepo>((ref) {
  final remote = ref.watch(signupRemoteDataSourceProvider);
  final local = ref.watch(signupLocalDataSourceProvider);
  final network = ref.watch(networkInfoProvider);
  return SignupRepoImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: network,
  );
});

/// UseCase Provider
final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final repo = ref.watch(signupRepoProvider);
  return SignupUseCase(repo);
});

/// Main Notifier Provider
final signupNotifierProvider =
    StateNotifierProvider<SignupNotifier, SignupState>((ref) {
  final useCase = ref.watch(signupUseCaseProvider);
  return SignupNotifier(useCase);
});
