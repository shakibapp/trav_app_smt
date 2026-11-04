# 🚀 GetX to Riverpod Clean Architecture Migration Guide
> **Project:** `hamishphipps` (Flutter App)  
> **Target Architecture:** Clean Architecture (Domain, Data, Presentation) + Riverpod  
> **Target Directory:** `lib/riverpod-version/`

---

## 📑 সূচিপত্র (Table of Contents)
1. [মাইগ্রেশন স্ট্র্যাটেজি (Parallel Migration Approach)](#1-মাইগ্রেশন-স্ট্র্যাটেজি-parallel-migration-approach)
2. [ধাপ ১: ডিপেনডেন্সি সেটআপ (pubspec.yaml)](#ধাপ-১-ডিপেনডেন্সি-সেটআপ-pubspecyaml)
3. [ধাপ ২: প্রজেক্ট রুট ইনিশিয়ালাইজেশন (main.dart)](#ধাপ-২-প্রজেক্ট-রুট-ইনিশিয়ালাইজেশন-maindart)
4. [ধাপ ৩: কোর সার্ভিসেস মাইগ্রেশন (Core Providers)](#ধাপ-৩-কোর-সার্ভিসেস-মাইগ্রেশন-core-providers)
5. [ধাপ ৪: `template.sh` স্ক্রিপ্ট ব্যবহারের নিয়ম](#ধাপ-৪-templatesh-স্ক্রিপ্ট-ব্যবহারের-নিয়ম)
6. [ধাপ ৫: কমপ্লিট কোড এক্সাম্পল (GetX ➔ Riverpod Clean Architecture)](#ধাপ-৫-কমপ্লিট-কোড-এক্সাম্পল-getx--riverpod-clean-architecture)
7. [ধাপ ৬: GetX মেথড কনভার্শন চিটশিট (GetX vs Riverpod/Flutter)](#ধাপ-৬-getx-মেথড-কনভার্শন-চিটশিট-getx-vs-riverpodflutter)
8. [ধাপ ৭: ফিচার মাইগ্রেশন রোডম্যাপ (চেকলিস্ট)](#ধাপ-৭-ফিচার-মাইগ্রেশন-রোডম্যাপ-চেকলিস্ট)
9. [ধাপ ৮: ফাইনাল ক্লিনআপ (GetX সম্পূর্ণ রিমুভ)](#ধাপ-৮-ফাইনাল-ক্লিনআপ-getx-সম্পূর্ণ-রিমুভ)

---

## 1. মাইগ্রেশন স্ট্র্যাটেজি (Parallel Migration Approach)

একসাথে পুরো প্রজেক্ট কনভার্ট করতে গেলে অ্যাপ ক্র্যাশ বা বাগ হওয়ার সম্ভাবনা বেশি থাকে। তাই আমরা **Parallel Migration** স্ট্র্যাটেজি ফলো করব:
- বর্তমানের `lib/app/` কোড সম্পূর্ণ অক্ষত থাকবে।
- নতুন ক্লিন আর্কিটেকচার কোডগুলো `lib/riverpod-version/` ফোল্ডারের ভেতরে তৈরি হবে।
- প্রতিটি ফিচার একে একে রিভারপডে তৈরি করার পর রাউটে পয়েন্ট করে টেস্ট করা হবে।
- সব ফিচার কনভার্ট হয়ে গেলে পুরনো GetX মডিউলগুলো ডিলিট করে দেওয়া হবে।

---

## ধাপ ১: ডিপেনডেন্সি সেটআপ (pubspec.yaml)

প্রজেক্টের `pubspec.yaml` ফাইলে `flutter_riverpod` যোগ করুন:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Riverpod State Management
  flutter_riverpod: ^2.6.1
  
  # Existing packages (keep them)
  flutter_screenutil:
  cached_network_image: ^3.4.1
  shared_preferences: ^2.5.4
  # ... অন্যান্য প্যাকেজ
```

টার্মিনালে রান করুন:
```bash
flutter pub get
```

---

## ধাপ ২: প্রজেক্ট রুট ইনিশিয়ালাইজেশন (main.dart)

Riverpod কাজ করার জন্য পুরো অ্যাপকে `ProviderScope` দিয়ে র‍্যাপ করতে হবে।

`lib/main.dart` এ `ProviderScope` যুক্ত করুন:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- ১. ইম্পোর্ট করুন
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // মাইগ্রেশন চলাকালীন সাময়িক থাকবে
import 'app/core/services/local_data.dart';
import 'app/core/services/network_manager.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalService.init();
  Get.put(NetworkManager(), permanent: true);

  // <-- ২. ProviderScope দিয়ে runApp র‍্যাপ করুন
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp( // মাইগ্রেশন শেষে এটি MaterialApp হয়ে যাবে
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.SPLASH,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
```

---

## ধাপ ৩: কোর সার্ভিসেস মাইগ্রেশন (Core Providers)

ফিচার তৈরির আগে গ্লোবাল সার্ভিসগুলোর রিভারপড প্রোভাইডার তৈরি করে নিন: `lib/riverpod-version/core/services/`

### ১. LocalStorage Provider (`local_storage_provider.dart`):
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart if using overrides');
});

final tokenProvider = StateProvider<String?>((ref) => null);
```

### ২. Network Connectivity Provider (`network_connectivity_provider.dart`):
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final connectivityStatusProvider = StreamProvider<InternetConnectionStatus>((ref) {
  return InternetConnectionChecker.createInstance().onStatusChange;
});
```

---

## ধাপ ৪: `template.sh` স্ক্রিপ্ট ব্যবহারের নিয়ম

প্রজেক্টের রুট ডিরেক্টরিতে `template.sh` স্ক্রিপ্টটি রেডি করা আছে। এটি যেকোনো ফিচারের জন্য ক্লিন আর্কিটেকচারের সব ফোল্ডার ও খালি ফাইল এক ক্লিকে জেনারেট করে।

### টার্মিনাল কমান্ড:
```bash
# অথেনটিকেশন / লগইন ফিচারের জন্য:
./template.sh auth/login

# হোম স্ক্রিনের জন্য:
./template.sh home

# ট্রিপস ফিচারের জন্য:
./template.sh trips
```

### জেনারেট হওয়া ফোল্ডার স্ট্রাকচার:
```
lib/riverpod-version/features/<feature_name>/
├── domain/                    # পিওর বিজনেস লজিক (নো থার্ড পার্টি কোড)
│   ├── entities/              # ডেটা স্ট্রাকচার (Plain Dart Class)
│   ├── repo/                  # রিপোজিটরি ইন্টারফেস / অ্যাবস্ট্রাক্ট ক্লাস
│   └── usecases/              # নির্দিষ্ট অ্যাকশন (যেমন: LoginUseCase)
├── data/                      # ডেটা ফেচিং এবং স্টোরেজ
│   ├── models/                # JSON Serialization সহ ডেটা মডেল
│   ├── datasources/           # রিমোট API কল এবং লোকাল DB/Prefs
│   └── repo/                  # Domain Repo এর বাস্তব রূপ (Impl)
└── presentation/              # ইউজার ইন্টারফেস এবং স্টেট
    ├── provider/              # Riverpod StateNotifier / Notifier
    └── <feature_name>_screen.dart # UI (ConsumerWidget)
```

---

## ধাপ ৫: কমপ্লিট কোড এক্সাম্পল (GetX ➔ Riverpod Clean Architecture)

ধরি, আমরা **`login`** ফিচারটি কনভার্ট করব:

### ১. Entity: `domain/entities/login_entity.dart`
```dart
class LoginEntity {
  final String email;
  final String token;
  final String userId;

  const LoginEntity({
    required this.email,
    required this.token,
    required this.userId,
  });
}
```

### ২. Repository Interface: `domain/repo/login_repo.dart`
```dart
import '../entities/login_entity.dart';

abstract class LoginRepo {
  Future<LoginEntity> login({required String email, required String password});
}
```

### ৩. UseCase: `domain/usecases/login_use_case.dart`
```dart
import '../entities/login_entity.dart';
import '../repo/login_repo.dart';

class LoginUseCase {
  final LoginRepo _repo;
  LoginUseCase(this._repo);

  Future<LoginEntity> call({required String email, required String password}) {
    return _repo.login(email: email, password: password);
  }
}
```

### ৪. Model: `data/models/login_model.dart`
```dart
import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.email,
    required super.token,
    required super.userId,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
```

### ৫. Remote DataSource: `data/datasources/login_remote_data_source.dart`
```dart
import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login(String email, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  @override
  Future<LoginModel> login(String email, String password) async {
    // এখানে আপনার API Request Handler ব্যবহার করুন
    // demo:
    return LoginModel(email: email, token: "jwt_token_here", userId: "123");
  }
}
```

### ৬. Repository Implementation: `data/repo/login_repo_impl.dart`
```dart
import '../../domain/entities/login_entity.dart';
import '../../domain/repo/login_repo.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepoImpl implements LoginRepo {
  final LoginRemoteDataSource remoteDataSource;
  LoginRepoImpl(this.remoteDataSource);

  @override
  Future<LoginEntity> login({required String email, required String password}) async {
    return await remoteDataSource.login(email, password);
  }
}
```

### ৭. Riverpod Notifier & State: `presentation/provider/login_notifier.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/login_remote_data_source.dart';
import '../../data/repo/login_repo_impl.dart';
import '../../domain/usecases/login_use_case.dart';

// স্টেট ক্লাস (Loading, Success, Error ট্র্যাক করার জন্য)
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  LoginState copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// StateNotifier
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginNotifier(this._loginUseCase) : super(const LoginState());

  Future<void> submitLogin(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _loginUseCase(email: email, password: password);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

// Providers Dependency Injection
final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSource>((ref) {
  return LoginRemoteDataSourceImpl();
});

final loginRepoProvider = Provider((ref) {
  return LoginRepoImpl(ref.watch(loginRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.watch(loginRepoProvider));
});

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.watch(loginUseCaseProvider));
});
```

### ৮. UI Screen: `presentation/login_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/login_notifier.dart';

// GetView বা StatelessWidget এর বদলে ConsumerWidget ব্যবহার করুন
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // স্টেট ওয়াচ করা (GetX এর Obx এর বিকল্প)
    final loginState = ref.watch(loginNotifierProvider);

    // লিসেনার (Error বা Success হ্যান্ডেল করতে)
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
      if (next.isSuccess) {
        // পরবর্তী স্ক্রিনে যাওয়া
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            loginState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      ref.read(loginNotifierProvider.notifier).submitLogin(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                    },
                    child: const Text('Sign In'),
                  ),
          ],
        ),
      ),
    );
  }
}
```

---

## ধাপ ৬: GetX মেথড কনভার্শন চিটশিট (GetX vs Riverpod/Flutter)

| কাজ | পূর্বে (GetX) | পরবর্তীতে (Riverpod / Flutter Native) |
|---|---|---|
| **স্টেট রিড করা** | `controller.value` | `ref.read(myProvider)` |
| **স্টেট ওয়াচ (UI আপডেট)** | `Obx(() => Text(c.name.value))` | `final val = ref.watch(myProvider);` |
| **অ্যাকশন মেথড কল** | `controller.login()` | `ref.read(myProvider.notifier).login()` |
| **স্ক্রিনে যাওয়া** | `Get.toNamed(AppRoutes.HOME)` | `Navigator.pushNamed(context, '/home')` |
| **স্ক্রিন থেকে ফিরে আসা** | `Get.back()` | `Navigator.pop(context)` |
| **সব ব্যাকস্ট্যাক মুছে যাওয়া**| `Get.offAllNamed(...)` | `Navigator.pushNamedAndRemoveUntil(context, ...)` |
| **স্ন্যাকবার দেখানো** | `Get.snackbar('Title', 'Msg')` | `ScaffoldMessenger.of(context).showSnackBar(...)` |
| **ডায়ালগ দেখানো** | `Get.dialog(...)` | `showDialog(context: context, builder: ...)` |
| **ডায়ালগ বন্ধ করা** | `Get.back()` | `Navigator.of(context, rootNavigator: true).pop()` |

---

## ধাপ ৭: ফিচার মাইগ্রেশন রোডম্যাপ (চেকলিস্ট)

অ্যাপের জটিলতা বিবেচনায় নিচের ক্রমানুসারে ফিচারগুলো কনভার্ট করার পরামর্শ দেওয়া হচ্ছে:

- [ ] **Phase 1: Authentication Flow**
  - [ ] `./template.sh auth/splash`
  - [ ] `./template.sh auth/login`
  - [ ] `./template.sh auth/signup`
  - [ ] `./template.sh auth/verify_otp`
  - [ ] `./template.sh auth/forgot_password`
  - [ ] `./template.sh auth/reset_password`

- [ ] **Phase 2: Common & Navigation**
  - [ ] `./template.sh nav_bar`
  - [ ] `./template.sh preferences`
  - [ ] `./template.sh profile`

- [ ] **Phase 3: Core General User Flow**
  - [ ] `./template.sh home`
  - [ ] `./template.sh trips`
  - [ ] `./template.sh trip_details_screen`
  - [ ] `./template.sh create_plan`
  - [ ] `./template.sh alerts_screen`

- [ ] **Phase 4: Parent Flow (if applicable)**
  - [ ] `./template.sh parent/parent_home`
  - [ ] `./template.sh parent/parent_trips`
  - [ ] `./template.sh parent/parent_alerts`
  - [ ] `./template.sh parent/parent_settings`

---

## ধাপ ৮: ফাইনাল ক্লিনআপ (GetX সম্পূর্ণ রিমুভ)

সব ফিচার রিভারপডে কনভার্ট হওয়ার পর:
1. `lib/main.dart` এ `GetMaterialApp` পরিবর্তন করে সাধারণ `MaterialApp` করুন।
2. `lib/app/` পুরনো ফোল্ডারটি ডিলিট করুন অথবা ব্যাকআপ রাখুন।
3. `pubspec.yaml` থেকে `get: ^4.7.3` রিমুভ করুন।
4. টার্মিনালে রান করুন:
   ```bash
   flutter pub get
   flutter run
   ```

---
*Happy Coding with Riverpod & Clean Architecture!* 🎯

