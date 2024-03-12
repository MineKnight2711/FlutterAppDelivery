// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/controller/map_controller.dart';
import 'package:trasua_delivery/widgets/custom_snackbar.dart';
import 'package:trasua_delivery/transitions/transition_animation.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class HomeScreenMapWidget extends StatelessWidget {
  final mapController = Get.find<MapController>();
  HomeScreenMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: MapWidget(
            key: const ValueKey("mapWidget"),

            // resourceOptions: ResourceOptions(
            //     accessToken:
            //         "pk.eyJ1IjoidGluaGthaXQiLCJhIjoiY2xoZXhkZmJ4MTB3MzNqczdza2MzcHE2YSJ9.tPQwbEWtA53iWlv3U8O0-g"),
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
