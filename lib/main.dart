import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trasua_delivery/controller/main_controller.dart';
import 'package:trasua_delivery/screens/slpash_screen.dart';

void main() async {
  await MainController.initializeControllers();
  runApp(
    const ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: AppDelivery(),
    ),
  );
}

class AppDelivery extends StatelessWidget {
  const AppDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: const [Locale("en", "US"), Locale("vi", "VN")],
      locale: const Locale("en", "US"),
      initialRoute: 'splash_screen',
      debugShowCheckedModeBanner: false,
      routes: {
        'splash_screen': (context) => const SplashScreen(),
      },
    );
  }
}
