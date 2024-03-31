// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/controller/deliver_controller.dart';
import 'package:trasua_delivery/screens/home/components/homescreen_drawer.dart';
import 'package:trasua_delivery/screens/home/components/map_widget.dart';

import '../../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _deliverController = Get.find<DeliverController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        appBar: HomeScreenAppBar(
          onAvatarTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: _deliverController.deliverModel.value != null
            ? HomeScreenDrawer(
                logoutPressed: () => _deliverController.logOut().whenComplete(
                    () => _scaffoldKey.currentState?.closeDrawer()),
              )
            : null,
        body: HomeScreenMapWidget(),
        bottomNavigationBar: Container(
            height: 60.h,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.center,
            child: SlideAction(
              sliderButtonIconSize: 10.r,
              onSubmit: () async {
                final result = await _deliverController.saveCurrentLocation();
                print(result);
              },
              text: "Bắt đầu làm việc",
              outerColor: AppColors.orange100,
              borderRadius: 5,
            )),
      ),
    );
  }
}
