import 'package:get/get.dart';
import 'package:trasua_delivery/controller/map_controller.dart';

class MainController {
  static initializeControllers() async {
    Get.put(MapController());
  }
}
