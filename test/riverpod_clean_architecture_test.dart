import 'package:flutter_test/flutter_test.dart';
import 'package:hamishphipps/riverpod-version/core/errors/failures.dart';
import 'package:hamishphipps/riverpod-version/core/utils/result.dart';
import 'package:hamishphipps/riverpod-version/features/auth/login/domain/entities/login_entity.dart';
import 'package:hamishphipps/riverpod-version/features/auth/login/domain/repo/login_repo.dart';
import 'package:hamishphipps/riverpod-version/features/auth/login/domain/usecases/login_use_case.dart';
import 'package:hamishphipps/riverpod-version/features/auth/signup/domain/entities/signup_entity.dart';

// Fake LoginRepo for Unit Testing
class FakeLoginRepo implements LoginRepo {
  @override
  Future<Result<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    if (email == 'test@example.com' && password == 'password123') {
      return const Result.success(
        LoginEntity(
          email: 'test@example.com',
          token: 'fake_jwt_token',
          role: 'USER',
          isEmailVerified: true,
          userId: 'user_123',
        ),
      );
    } else {
      return const Result.failure(
        AuthFailure('Invalid email or password'),
      );
    }
  }

  @override
  Future<Result<void>> saveSession({
    required String token,
    required String role,
    required String email,
  }) async {
    return const Result.success(null);
  }

  @override
  Future<Result<bool>> isUserLoggedIn() async {
    return const Result.success(true);
  }
}

void main() {
  group('Clean Architecture Result Pattern Tests', () {
    test('Result.success holds correct data and isSuccess is true', () {
      const result = Result.success('test_data');
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals('test_data'));
    });

    test('Result.failure holds failure and isFailure is true', () {
      const result = Result.failure(ServerFailure('Server Down'));
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.message, equals('Server Down'));
    });
  });

  group('Login Domain Layer Tests', () {
    late LoginUseCase loginUseCase;
    late FakeLoginRepo fakeRepo;

    setUp(() {
      fakeRepo = FakeLoginRepo();
      loginUseCase = LoginUseCase(fakeRepo);
    });

    test('should return LoginEntity when credentials are valid', () async {
      final result = await loginUseCase(
        const LoginParams(
          email: 'test@example.com',
          password: 'password123',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.email, equals('test@example.com'));
      expect(result.dataOrNull?.token, equals('fake_jwt_token'));
    });

    test('should return AuthFailure when credentials are invalid', () async {
      final result = await loginUseCase(
        const LoginParams(
          email: 'wrong@example.com',
          password: 'wrongpassword',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
      expect(result.failureOrNull?.message, equals('Invalid email or password'));
    });
  });

  group('Signup Entity Tests', () {
    test('SignupEntity instantiated correctly with default emailVerified false', () {
      const entity = SignupEntity(
        email: 'newuser@example.com',
        fullName: 'John Doe',
        userId: '999',
      );

      expect(entity.email, equals('newuser@example.com'));
      expect(entity.fullName, equals('John Doe'));
      expect(entity.isEmailVerified, isFalse);
    });
  });
}
