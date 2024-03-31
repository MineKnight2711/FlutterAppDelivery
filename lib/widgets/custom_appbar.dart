import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/config/font.dart';
import 'package:trasua_delivery/controller/deliver_controller.dart';
import 'package:trasua_delivery/screens/login/login_screen.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onAvatarTap;
  HomeScreenAppBar({super.key, this.onAvatarTap});
  final _deliverController = Get.find<DeliverController>();
  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Set the status bar color
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final deliver = _deliverController.deliverModel.value;
    return SafeArea(
      top: true,
      child: Container(
        color: Colors.white,
        height: 50.h,
        width: 0.9.sw,
        child: Obx(
          () {
            if (_deliverController.deliverModel.value != null) {
              return Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundImage:
                          Image.network("${deliver?.imageUrl}").image,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${_deliverController.deliverModel.value?.deliverName}",
                        style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                      ),
                      deliver?.workState ?? false
                          ? Text(
                              "Đang làm việc",
                              style:
                                  CustomFonts.customGoogleFonts(fontSize: 14.r),
                            )
                          : Text(
                              "Đang tạm nghỉ",
                              style:
                                  CustomFonts.customGoogleFonts(fontSize: 14.r),
                            ),
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () =>
                      Get.to(LoginScreen(), transition: Transition.downToUp),
                  child: CircleAvatar(
                    radius: 20.r,
                    child: const Icon(CupertinoIcons.person),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Đăng nhập",
                  style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading, centeredTitle;
  final VoidCallback? onPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Color? backGroundColor;
  final Color? leadingColor;
  const CustomAppBar(
      {super.key,
      this.title,
      this.showLeading = true,
      this.onPressed,
      this.bottom,
      this.actions,
      this.backGroundColor,
      this.leadingColor,
      this.centeredTitle = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backGroundColor ?? AppColors.orange100,
      elevation: 0,
      centerTitle: centeredTitle,
      leading: showLeading
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onPressed ??
                    () {
                      Navigator.pop(context);
                    },
                child: Icon(Icons.arrow_back,
                    color: leadingColor ?? AppColors.white100),
              ),
            )
          : null,
      actions: actions,
      title: Text(
        title ?? "",
        style: GoogleFonts.nunito(
          color: AppColors.white100,
          fontSize: (1 / 37).r,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
