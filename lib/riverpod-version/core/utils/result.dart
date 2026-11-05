import '../errors/failures.dart';

/// ============================================================================
/// [Result<T>] - FUNCTIONAL ERROR HANDLING
/// ============================================================================
/// সিনিয়র ডেভেলপাররা প্রেজেন্টেশন এবং ডোমেইনে try-catch এর বদলে Result/Either
/// প্যাটার্ন ফলো করেন। এর মাধ্যমে একটি ফাংশন নিশ্চিতভাবে হয় Success ডাটা দিবে,
/// অথবা Failure দিবে। কোনো আনহ্যান্ডেলড এক্সেপশন অ্যাপ ক্র্যাশ করবে না।
/// 
/// ব্যবহার:
/// ```dart
/// final result = await loginUseCase(params);
/// result.when(
///   success: (data) => print('User logged in: ${data.email}'),
///   failure: (failure) => print('Login failed: ${failure.message}'),
/// );
/// ```
/// ============================================================================

sealed class Result<T> {
  const Result();

  /// সাকসেস ফ্যাক্টরি কনস্ট্রাক্টর
  const factory Result.success(T data) = Success<T>;

  /// ফেইলিউর ফ্যাক্টরি কনস্ট্রাক্টর
  const factory Result.failure(Failure failure) = Error<T>;

  /// সাকসেস কি না চেক করার হেল্পার
  bool get isSuccess => this is Success<T>;

  /// এরর কি না চেক করার হেল্পার
  bool get isFailure => this is Error<T>;

  /// সাকসেস হলে ডাটা রিটার্ন করবে, অন্যথায় null
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;

  /// ফেইলিউর হলে Failure রিটার্ন করবে, অন্যথায় null
  Failure? get failureOrNull =>
      this is Error<T> ? (this as Error<T>).failure : null;

  /// প্যাটার্ন ম্যাচিং মেথড (Dart 3 এর সুইচ বা এই when মেথড দুটোই ব্যবহারযোগ্য)
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Error<T>) {
      return failure((this as Error<T>).failure);
    }
    throw StateError('Unknown Result type');
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

