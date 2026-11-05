import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/core/services/local_data.dart';
import 'app/core/services/network_manager.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'riverpod-version/core/storage/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalService.init();
  final sharedPrefs = await SharedPreferences.getInstance();
  Get.put(NetworkManager(), permanent: true);

  // ProviderScope দিয়ে পুরো অ্যাপ র‍্যাপ করা হয়েছে যাতে Riverpod কাজ করে
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final Upgrader _upgrader = Upgrader(
    debugLogging: true,
    durationUntilAlertAgain: const Duration(hours: 1),
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.SPLASH,
          getPages: AppPages.pages,
          builder: (context, widget) {
            return UpgradeAlert(
              upgrader: _upgrader,
              navigatorKey: Get.key,
              child: widget ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
