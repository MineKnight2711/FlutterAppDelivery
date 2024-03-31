import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:trasua_delivery/controller/deliver_controller.dart';
import 'package:trasua_delivery/screens/home/home_screen.dart';
import 'package:trasua_delivery/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _deliverController = Get.find<DeliverController>();
  @override
  void initState() {
    super.initState();

    simulateInitialDataLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LottieBuilder.asset(
          "assets/animations/delivery_man_stop.json",
          width: 250.w,
          height: 250.w,
        ),
      ),
    );
  }

  Future<Timer> simulateInitialDataLoading() async {
    print(_deliverController.deliverModel.value?.deliverName);
    return Timer(
      const Duration(seconds: 2),
      () => Get.offAll(
        _deliverController.deliverModel.value != null
            ? const HomeScreen()
            : LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(
          milliseconds: 1000,
        ),
      ),
    );
  }
}
