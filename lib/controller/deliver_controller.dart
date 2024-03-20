import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:trasua_delivery/api/deliver_api.dart';

class DeliverController extends GetxController {
  late DeliverApi _deliverApi;
  @override
  void onInit() {
    super.onInit();
    _deliverApi = DeliverApi();
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
}
