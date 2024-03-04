import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trasua_delivery/api/base_url.dart';
import 'package:trasua_delivery/model/respone_base_model.dart';

class MapApi {
  final goongApiKey = "1D1TShB6BE7zzAKPIlT7GF61V0wa6KnsO8UAnl1P";

  Future<ResponseBaseModel> getLocationByID(String placeId) async {
    final Uri uri = Uri.parse(
        "${ApiUrl.apiGoongMapBaseUrl}/Place/Detail?place_id=$placeId&api_key=$goongApiKey");
    final response = await http.get(uri);
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }

  Future<ResponseBaseModel> findRoute() async {
    String startLocation = "10.7420041,106.713203";
    String endLocation = "10.855145893000042,106.78536445000009";
    String vehicle = "bike";
    final Uri uri = Uri.parse(
        "${ApiUrl.apiGoongMapBaseUrl}/Direction?origin=$startLocation&destination=$endLocation&api_key=$goongApiKey&vehicle=$vehicle");
    final response = await http.get(uri);
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }

  Future<ResponseBaseModel> getLocationByLatitude(
      String lat, String longLat) async {
    final Uri uri = Uri.parse(
        "${ApiUrl.apiGoongMapBaseUrl}/Geocode?latlng=$lat,$longLat&api_key=$goongApiKey");
    final response = await http.get(uri);
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }

  Future<ResponseBaseModel> getPredictLocation(String predictString) async {
    final response = await http.get(
      Uri.parse(
          "${ApiUrl.apiGoongMapBaseUrl}/Place/AutoComplete?api_key=$goongApiKey&input=$predictString"),
    );
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }

  Future<ResponseBaseModel> getAddressLatitude(String address) async {
    final response = await http.get(
      Uri.parse(
          "${ApiUrl.apiGoongMapBaseUrl}/geocode?address=$address&api_key=$goongApiKey"),
    );
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase.data = jsonDecode(utf8.decode(response.bodyBytes));
      responseBase.message = "Success";
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }
}
