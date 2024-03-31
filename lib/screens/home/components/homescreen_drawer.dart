import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trasua_delivery/config/font.dart';
import 'package:trasua_delivery/controller/deliver_controller.dart';

class HomeScreenDrawer extends StatelessWidget {
  final VoidCallback logoutPressed;
  HomeScreenDrawer({super.key, required this.logoutPressed});
  final _deliverController = Get.find<DeliverController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: Image.network(
                            "${_deliverController.deliverModel.value?.imageUrl}")
                        .image,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "${_deliverController.deliverModel.value?.deliverName}",
                    style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                  ),
                  Divider(
                    thickness: 0.5.h,
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: Text(
                'Đơn hàng',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: Text(
                'Trạng thái làm việc',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              trailing: Transform.scale(
                scale: 0.8,
                child: SizedBox(
                  width: 30.w,
                  child: Obx(
                    () => Switch(
                      value: _deliverController.deliverModel.value?.workState ??
                          false,
                      onChanged: (value) {
                        _deliverController.deliverModel.update((val) {
                          val?.workState = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'Cài đặt',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(
                'Đăng xuất',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              onTap: logoutPressed,
            ),
          ],
        ),
      ),
    );
  }
}
