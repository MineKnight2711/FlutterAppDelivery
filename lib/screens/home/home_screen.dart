// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:trasua_delivery/config/font.dart';
import 'package:trasua_delivery/controller/map_controller.dart';
import 'package:trasua_delivery/screens/home/components/map_widget.dart';

import '../../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeScreenAppBar(
        onAvatarTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: HomeScreenDrawer(),
      body: HomeScreenMapWidget(),
    );
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
