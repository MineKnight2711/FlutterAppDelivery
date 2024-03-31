import 'dart:ffi';

class DeliverModel {
  int? deliverID;
  String? deliverName;
  String? imageUrl;
  double? latitude;
  double? longitude;
  bool? workState;
  String? phoneNumber;

  DeliverModel({
    this.deliverID,
    this.deliverName,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.workState,
    this.phoneNumber,
  });

  factory DeliverModel.fromJson(Map<String, dynamic> json) {
    return DeliverModel(
      deliverID: json['deliverID'],
      deliverName: json['deliverName'],
      imageUrl: json['imageUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      workState: json['workState'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliverID': deliverID,
      'deliverName': deliverName,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'workState': workState,
      'phoneNumber': phoneNumber,
    };
  }
}
