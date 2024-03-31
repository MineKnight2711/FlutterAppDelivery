import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart'
    as gpi;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trasua_delivery/api/map_api.dart';
import 'package:trasua_delivery/model/location_model.dart';
import 'package:trasua_delivery/model/predict_location_model.dart';
import 'package:trasua_delivery/model/respone_base_model.dart';
import 'package:trasua_delivery/model/route_model.dart';

class MapController extends GetxController {
  late MapApi _mapApi;
  Rx<MapboxMap?> mapboxMap = Rx<MapboxMap?>(null);
  Rx<BaseAnnotationManager?> pointManager = Rx<PointAnnotationManager?>(null);
  Rx<PolylineAnnotationManager?> polylineManager =
      Rx<PolylineAnnotationManager?>(null);
  RxInt mapWidgetKey = 0.obs;
  RxDouble zoomLevel = 15.0.obs;

  RxBool isShow = false.obs;
  RxBool isHidden = true.obs;

  RxString searchText = "".obs;
  RxString latitude = "".obs;
  RxString longLatitude = "".obs;

  Rx<List<Prediction>> places = Rx<List<Prediction>>([]);
  final TextEditingController searchController = TextEditingController();
  Rx<Result?> details = Rx<Result?>(null);
  Rx<LocationResponse?> selectedLocation = Rx<LocationResponse?>(null);
  @override
  void onInit() {
    super.onInit();
    MapboxOptions.setAccessToken(
        "pk.eyJ1IjoidGluaGthaXQiLCJhIjoiY2xoZXhkZmJ4MTB3MzNqczdza2MzcHE2YSJ9.tPQwbEWtA53iWlv3U8O0-g");
    _mapApi = MapApi();
  }

  @override
  void refresh() {
    super.refresh();
    searchText.value = latitude.value = longLatitude.value = "";
    isShow.value = false;
    isHidden.value = true;
    selectedLocation.value = null;
    searchController.clear();
  }

  onMapCreated(MapboxMap mapboxMapCreate) {
    mapboxMap.value = mapboxMapCreate;
  }

  void zoomIn() {
    zoomLevel.value++;
    mapboxMap.value?.flyTo(
        CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: zoomLevel.value,
            bearing: 0,
            pitch: 0),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  void zoomOut() {
    zoomLevel.value--;
    mapboxMap.value?.flyTo(
        CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: zoomLevel.value,
            bearing: 0,
            pitch: 0),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  Future<String> predictLocation(String predictString) async {
    ResponseBaseModel responseBaseModel =
        await _mapApi.getPredictLocation(predictString);

    if (responseBaseModel.message == "Success") {
      PredictLocationResponse locationResponse =
          PredictLocationResponse.fromJson(responseBaseModel.data);
      places.value = locationResponse.predictions;
      isShow.value = true;
      isHidden.value = true;

      return "Success";
    }

    return responseBaseModel.message ?? "";
  }

  Future<String> getLocation(String placesID) async {
    searchController.clear();
    isShow.value = false;
    isHidden.value = false;
    ResponseBaseModel responseBaseModel =
        await _mapApi.getLocationByID(placesID);

    if (responseBaseModel.message == "Success") {
      LocationResponse locationResult =
          LocationResponse.fromJson(responseBaseModel.data);
      details.value = locationResult.results;
      latitude.value = "${details.value?.geometry.location.lat}";
      longLatitude.value = "${details.value?.geometry.location.lng}";
      centerCameraOnCoordinate(
          double.parse(latitude.value), double.parse(longLatitude.value));
      selectedLocation.value = locationResult;
    }

    return responseBaseModel.message ?? "";
  }

  Future<String> findCurrentLocation() async {
    return await getCurrentPosition();
  }

  void selectAddress() {}
  Future<String> getCurrentPosition() async {
    String result = "";
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.deniedForever) {
      result = 'DeniedForever';
    } else if (permission == geolocator.LocationPermission.denied) {
      result = "Denied";
      geolocator.LocationPermission requestPermission =
          await geolocator.Geolocator.requestPermission();
      if (requestPermission == geolocator.LocationPermission.deniedForever) {
        return "DeniedForever";
      }
    } else if (permission == geolocator.LocationPermission.whileInUse ||
        permission == geolocator.LocationPermission.always) {
      gpi.Position position = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      Position getPositon = Position(position.longitude, position.latitude);
      final locationResult =
          await getLocationByLatitude("${getPositon.lat}", "${getPositon.lng}");
      if (locationResult == "Success") {
        centerCameraOnCoordinate(
            getPositon.lat.toDouble(), getPositon.lng.toDouble());
      }
      return "Success";
    }

    return result;
  }

  Future<String> getLocationByLatitude(String lat, String longLat) async {
    searchController.clear();
    isShow.value = false;
    isHidden.value = false;
    ResponseBaseModel responseBaseModel =
        await _mapApi.getLocationByLatitude(lat, longLat);

    if (responseBaseModel.message == "Success") {
      LocationByLatitudeResponse locationResult =
          LocationByLatitudeResponse.fromJson(responseBaseModel.data);
      final resultAddress = locationResult.results[0];
      selectedLocation.value =
          LocationResponse(results: resultAddress, status: "OK");
      return responseBaseModel.message ?? "";
    }

    return responseBaseModel.message ?? "";
  }

  void moveToCurrentPosition(double lat, double longLat) {
    resetPointAndPolyline();

    // Set the camera center to the new location
    mapboxMap.value?.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(longLat, lat),
        ).toJson(),
      ),
    );

    mapboxMap.value?.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      pointManager.value = pointAnnotationManager;
      final ByteData bytes =
          await rootBundle.load('assets/images/delivery.png');
      final Uint8List imagesData = bytes.buffer.asUint8List();
      pointAnnotationManager.create(
        PointAnnotationOptions(
          iconSize: 1.5,
          image: imagesData,
          geometry: Point(coordinates: Position(longLat, lat)).toJson(),
        ),
      );
    });
  }

  void centerCameraOnCoordinate(double lat, double longLat) {
    resetPointAndPolyline();
    mapboxMap.value?.setCamera(CameraOptions(
        center: Point(
          coordinates: Position(longLat, lat),
        ).toJson(),
        zoom: 12.0));

    mapboxMap.value?.flyTo(
        CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            zoom: 15,
            bearing: 180,
            pitch: 30),
        MapAnimationOptions(duration: 3000, startDelay: 0));
    mapboxMap.value?.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      pointManager.value = pointAnnotationManager;
      final ByteData bytes =
          await rootBundle.load('assets/images/location_64.png');
      final Uint8List imagesData = bytes.buffer.asUint8List();

      pointAnnotationManager.create(PointAnnotationOptions(
          iconSize: 1.5,
          image: imagesData,
          geometry: Point(coordinates: Position(longLat, lat)).toJson()));
    });
    // PointAnnotation(iconimages: )
    // CircleAnnotationOptions(
    //   geometry: Point(coordinates: Position(longLat, lat)).toJson(),
    //   circleColor: AppColors.orange100.value,
    //   circleRadius: 12.0,
    // ),
  }

  Future<void> findRoute() async {
    final response = await _mapApi.findRoute();
    if (response.message == "Success") {
      Directions directions = Directions.fromJson(response.data);
      final firstResult = directions.routes[0].legs[0];

      createEndAndStartPoints(
          firstResult.start_location.lat,
          firstResult.start_location.lng,
          firstResult.end_location.lat,
          firstResult.end_location.lng);
      mapboxMap.value?.annotations
          .createPolylineAnnotationManager()
          .then((polylineAnnotationManager) async {
        polylineManager.value = polylineAnnotationManager;

        final positions = <List<Position>>[];

        for (var step in firstResult.steps) {
          positions.add(
            [
              Position(step.start_location.lng, step.start_location.lat),
              Position(step.end_location.lng, step.end_location.lat),
            ],
          );
        }

        polylineAnnotationManager.createMulti(positions
            .map((e) => PolylineAnnotationOptions(
                geometry: LineString(coordinates: e).toJson(),
                lineColor: Color(0xffFE724C).value,
                lineWidth: 3))
            .toList());
      });
      centerCameraOnCoordinate(
          firstResult.start_location.lat, firstResult.start_location.lng);
    }
  }

  void createEndAndStartPoints(
      double startLat, double startLng, double endLat, double endLng) {
    resetPointAndPolyline();
    mapboxMap.value?.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      pointManager.value = pointAnnotationManager;
      List<Position> postions = [];
      postions.add(Position(startLat, startLng));
      postions.add(Position(endLat, endLng));
      final postionOptions = <PointAnnotationOptions>[];
      final ByteData bytes =
          await rootBundle.load('assets/images/location_64.png');
      final Uint8List imagesData = bytes.buffer.asUint8List();
      for (Position p in postions) {
        postionOptions.add(PointAnnotationOptions(
            geometry: Point(coordinates: p).toJson(), image: imagesData));
      }
      pointAnnotationManager.createMulti(postionOptions);
    });
  }

  Future<String> getOrderAddressLatitude(String address) async {
    final response = await _mapApi.getAddressLatitude(address);
    if (response.message == "Success") {
      LocationByLatitudeResponse location =
          LocationByLatitudeResponse.fromJson(response.data);
      final firstResult = location.results[0];

      drawLineBetweenTwoPoints(
          firstResult.geometry.location.lat, firstResult.geometry.location.lng);
    }
    return response.message ?? "";
  }

  void resetPointAndPolyline() {
    if (pointManager.value != null) {
      mapboxMap.value?.annotations.removeAnnotationManager(pointManager.value!);
    }
    if (polylineManager.value != null) {
      mapboxMap.value?.annotations
          .removeAnnotationManager(polylineManager.value!);
    }
  }

  void createEndPoint(double lat, double lng) {
    mapboxMap.value?.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      pointManager.value = pointAnnotationManager;
      final ByteData bytes =
          await rootBundle.load('assets/images/location_64.png');
      final Uint8List imagesData = bytes.buffer.asUint8List();

      pointAnnotationManager.create(PointAnnotationOptions(
          iconSize: 1.5,
          image: imagesData,
          geometry: Point(coordinates: Position(lng, lat)).toJson()));
    });
  }

  void drawLineBetweenTwoPoints(double lat, double lng) async {
    gpi.Position? currentPostion = await getCurrentPositionForDelivery();
    if (currentPostion != null) {
      createEndAndStartPoints(
          currentPostion.latitude, currentPostion.longitude, lat, lng);
      mapboxMap.value?.annotations
          .createPolylineAnnotationManager()
          .then((polylineAnnotationManager) async {
        polylineManager.value = polylineAnnotationManager;
        List<Position> positions = [];

        positions.add(Position(lng, lat));
        positions
            .add(Position(currentPostion.longitude, currentPostion.latitude));

        polylineAnnotationManager.create(PolylineAnnotationOptions(
            geometry: LineString(coordinates: positions).toJson(),
            lineColor: Color(0xffFE724C).value,
            lineWidth: 3));
      });
    }
  }

  Future<gpi.Position?> getCurrentPositionForDelivery() async {
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.deniedForever) {
    } else if (permission == geolocator.LocationPermission.denied) {
      geolocator.LocationPermission requestPermission =
          await geolocator.Geolocator.requestPermission();
      if (requestPermission == geolocator.LocationPermission.deniedForever) {
        return null;
      }
    } else if (permission == geolocator.LocationPermission.whileInUse ||
        permission == geolocator.LocationPermission.always) {
      gpi.Position position = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      Position getPositon = Position(position.longitude, position.latitude);
      centerCameraOnCoordinate(
          getPositon.lat.toDouble(), getPositon.lng.toDouble());
      return position;
    }

    return null;
  }
}
