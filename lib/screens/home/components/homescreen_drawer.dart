import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trasua_delivery/config/font.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

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
                            "https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp")
                        .image,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Tên người giao hàng",
                    style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                  ),
                  Divider(
                    thickness: 0.5.h,
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: Text(
                'Trạng thái làm việc',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(
                'Cài đặt',
                style: CustomFonts.customGoogleFonts(fontSize: 14.r),
              ),
              onTap: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
