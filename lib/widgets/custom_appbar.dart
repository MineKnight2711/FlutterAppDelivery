import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/config/font.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onAvatarTap;
  const HomeScreenAppBar({super.key, this.onAvatarTap});
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

    return SafeArea(
      top: true,
      child: Container(
        color: Colors.white,
        height: 50.h,
        width: 0.9.sw,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: onAvatarTap,
              // scaffoldKey.currentState?.openDrawer();
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: Image.network(
                        "https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp")
                    .image,
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
                  "Tên người giao hàng",
                  style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                ),
                Text(
                  "Trạng thái",
                  style: CustomFonts.customGoogleFonts(fontSize: 14.r),
                ),
              ],
            ),
          ],
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
