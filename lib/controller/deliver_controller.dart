import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:trasua_delivery/api/deliver_api.dart';
import 'package:trasua_delivery/controller/encrypt_controller.dart';

class DeliverController extends GetxController {
  late DeliverApi _deliverApi;
  late RSAEncryptDecrypt _rsaEncryptDecrypt;
  @override
  void onInit() {
    super.onInit();
    _deliverApi = DeliverApi();
    _rsaEncryptDecrypt = Get.find<RSAEncryptDecrypt>();
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
    final currentPostion = await geo.Geolocator.getCurrentPosition();
    await _deliverApi.saveCurrentLocation(
        1, currentPostion.latitude, currentPostion.longitude);
    // await
    // result = "Success";
    return result;
  }

  Future<String> login(String phoneNumber) async {
    final result = await _rsaEncryptDecrypt.encrypt(phoneNumber);
    if (result != "Fail") {
      final response = await _deliverApi.login(result);
    }
    return "Fail";
  }
}
