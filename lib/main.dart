import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/core/services/local_data.dart';
import 'app/core/services/network_manager.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalService.init();
  Get.put(NetworkManager(), permanent: true);
  runApp(MainApp());
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
