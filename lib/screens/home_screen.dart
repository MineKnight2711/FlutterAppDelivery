import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/config/font.dart';
import 'package:trasua_delivery/controller/map_controller.dart';
import 'package:trasua_delivery/transitions/transition_animation.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

import '../widgets/custom_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mapController = Get.put(MapController());
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: HomeScreenAppBar(),
      ),
      body: Stack(
        children: [
          SizedBox(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions: ResourceOptions(
                  accessToken:
                      "pk.eyJ1IjoidGluaGthaXQiLCJhIjoiY2xoZXhkZmJ4MTB3MzNqczdza2MzcHE2YSJ9.tPQwbEWtA53iWlv3U8O0-g"),
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(106.702765, 11)).toJson(),
                zoom: 10,
              ),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              textureView: true,
              onMapCreated: mapController.onMapCreated,
            ),
          ),
          Positioned(
            bottom: 130,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MapNavigateButton(
                    onPressed: mapController.zoomIn,
                    iconData: CupertinoIcons.zoom_in),
                MapNavigateButton(
                    onPressed: mapController.zoomOut,
                    iconData: CupertinoIcons.zoom_out),
                MapNavigateButton(
                  onPressed: () async {
                    String result = await mapController.findCurrentLocation();
                    switch (result) {
                      case "Success":
                        showDelayedLoadingAnimation(
                            context, "assets/animations/loading.json", 160, 1);
                        break;
                      case "DeniedForever":
                        Get.dialog(AlertDialog(
                          title: const Text("Enable Location!"),
                          content: const Text(
                              "Please enable location services to access your location!"),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                geolocator.Geolocator.openLocationSettings();
                                Get.back();
                              },
                            )
                          ],
                        ));
                        break;
                      case "Denied":
                        CustomSnackBar.showCustomSnackBar(
                            context, "Vui lòng bật cài đặt vị trí",
                            duration: 2,
                            type: FlushbarType.info,
                            isShowOnTop: false);

                      default:
                        break;
                    }
                  },
                  iconData: CupertinoIcons.location,
                ),
                MapNavigateButton(
                  onPressed: () async {
                    await mapController.findRoute();
                  },
                  iconData: Icons.route,
                ),
              ],
            ),
          ),
        ],
      ),
      // Container(
      //     color: Colors.transparent,
      //     margin: EdgeInsets.only(top: 0.03.sh),
      //     // height: 10.h,
      //     child: Row(
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.all(8.0),
      //           height: 50.h,
      //           child: Row(
      //             children: [
      //               CircleAvatar(
      //                 radius: 20.r,
      //                 backgroundImage: Image.network(
      //                         "https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp")
      //                     .image,
      //               ),
      //               SizedBox(
      //                 width: 10.w,
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   const Text("Tên người giao"),
      //                   SizedBox(
      //                     height: 5.h,
      //                   ),
      //                   const Text("Trạng thái"),
      //                 ],
      //               )
      //             ],
      //           ),
      //         )
      //       ],
      //     )),

      // NotificationListener<OverscrollIndicatorNotification>(
      //   onNotification: (overscroll) {
      //     overscroll.disallowIndicator();
      //     return true;
      //   },
      //   child: CustomScrollView(
      //     slivers: [
      //       SliverLayoutBuilder(
      //         builder: (context, constraints) {
      //           final isScrolledUnder = (constraints.scrollOffset > 200 - 50);
      //           print(isScrolledUnder);
      //           return SliverAppBar(
      //             expandedHeight: isScrolledUnder ? 0 : 0.1.sh,
      //             floating: false,
      //             backgroundColor: Colors.transparent,
      //             flexibleSpace: FlexibleSpaceBar(
      //               background: AnimatedOpacity(
      //                 opacity: !isScrolledUnder ? 1 : 0,
      //                 duration: const Duration(milliseconds: 2),
      //                 curve: const Cubic(0.2, 0.0, 0.0, 1.0),
      //                 child:
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //       SliverToBoxAdapter(
      //         child: Column(
      //           children: [
      //             const Padding(
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     "Top Food",
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       fontWeight: FontWeight.w700,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Container(
      //               color: Colors.amber,
      //               height: 0.7.sh,
      //             )
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // bottomNavigationBar:
      // Container(
      //   width: double.infinity,
      //   height: 0.2.sh,
      //   color: Colors.white,
      //   alignment: Alignment.bottomCenter,
      //   child: SizedBox(
      //     width: 0.8.sw,
      //     child: SlideAction(
      //       sliderButtonIconSize: 14.r,
      //       height: 0.07.sh,
      //       text: "Sẵn sàng nhận đơn",
      //       onSubmit: () {},
      //       sliderRotate: false,
      //       elevation: 24,
      //     ),
      //   ),
      // ),
    );
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 50.h,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: Image.network(
                    "https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp")
                .image,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tên người giao",
                style: CustomFonts.customGoogleFonts(
                    color: AppColors.dark100, fontSize: 14.r),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "Trạng thái",
                style: CustomFonts.customGoogleFonts(
                    color: AppColors.dark100, fontSize: 14.r),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MapNavigateButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  const MapNavigateButton({
    super.key,
    this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: AppColors.orange100, // Make the button circular
          padding: const EdgeInsets.all(18),
        ),
        child: Icon(
          iconData,
          size: 22,
          color: AppColors.white100,
        ),
      ),
    );
  }
}
