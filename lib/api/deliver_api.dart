import 'dart:convert';

import 'package:trasua_delivery/api/base_url.dart';
import 'package:trasua_delivery/model/respone_base_model.dart';
import 'package:http/http.dart' as http;

class DeliverApi {
  Future<ResponseBaseModel> saveCurrentLocation(
      int deliverId, double latitude, double longitude) async {
    final url = Uri.parse(
        "${ApiUrl.apiSaveLocation}/$deliverId?latitude=$latitude&longitude=$longitude");
    final response = await http.post(url);
    ResponseBaseModel responseBase = ResponseBaseModel();
    print(response.statusCode);
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }
}
