import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasua_delivery/api/deliver_api.dart';
import 'package:trasua_delivery/controller/encrypt_controller.dart';
import 'package:trasua_delivery/controller/map_controller.dart';
import 'package:trasua_delivery/model/deliver_model.dart';

class DeliverController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Rx<DeliverModel?> deliverModel = Rx<DeliverModel?>(null);
  late DeliverApi _deliverApi;
  late MapController _mapController;
  late RSAEncryptDecrypt _rsaEncryptDecrypt;
  late Timer? timer;
  @override
  void onInit() {
    super.onInit();
    _deliverApi = DeliverApi();
    _rsaEncryptDecrypt = Get.find<RSAEncryptDecrypt>();
    _mapController = Get.find<MapController>();
    getUserFromSharedPreferences();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> storedDeliverToSharedRefererces(
      DeliverModel? deliverModel) async {
    final SharedPreferences prefs = await _prefs;
    final deliverJsonEncode = jsonEncode(deliverModel?.toJson());
    await prefs.setString("current_deliver", deliverJsonEncode);
  }

  Future<DeliverModel?> getUserFromSharedPreferences() async {
    final SharedPreferences prefs = await _prefs;
    final jsonString = prefs.getString('current_deliver') ?? '';
    if (jsonString.isNotEmpty) {
      deliverModel.value = DeliverModel.fromJson(jsonDecode(jsonString));
      return deliverModel.value;
    }
    return null;
  }

  Future<String> saveCurrentLocation() async {
    String result = "";

    await geo.Geolocator.requestPermission().whenComplete(() async {
      if (await geo.Geolocator.isLocationServiceEnabled()) {
        result = "ServiceIsEnable";
      } else {
        result = "LocationDisable";
      }
    });

    if (result == "ServiceIsEnable") {
      _mapController.zoomIn();
      // Start the timer
      timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) async {
        final currentPosition = await geo.Geolocator.getCurrentPosition();
        final latitude = currentPosition.latitude;
        final longitude = currentPosition.longitude;
        // Save to cache (shared preferences) every 5 seconds
        final prefs = await _prefs;
        await prefs.setDouble('latitude', latitude);
        await prefs.setDouble('longitude', longitude);
        print(
            "Current lat,long ${prefs.getDouble("latitude")},${prefs.getDouble("longitude")}");

        // Save to database every 15 seconds
        if (timer.tick % 3 == 0) {
          _deliverApi.saveCurrentLocation(1, latitude, longitude);
        }
        _mapController.moveToCurrentPosition(latitude, longitude);
      });

      result = "Success";
    }

    return result;
  }

  Future<String> login(String phoneNumber) async {
    final result = await _rsaEncryptDecrypt.encrypt(phoneNumber);
    if (result != "Fail") {
      final response = await _deliverApi.login(result);
      if (response.status == "Success") {
        deliverModel.value = DeliverModel.fromJson(response.data);
        await storedDeliverToSharedRefererces(deliverModel.value);
        return "Success";
      }
      return "Fail";
    }
    return "Fail";
  }

  Future logOut() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('current_deliver');
    deliverModel.value = null;
  }
}
