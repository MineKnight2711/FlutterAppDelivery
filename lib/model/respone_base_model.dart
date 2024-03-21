class ResponseBaseModel {
  String? id;
  String? apiVersion;
  String? status;
  String? message;
  dynamic data;

  ResponseBaseModel({
    this.apiVersion,
    this.id,
    this.status,
    this.message,
    this.data,
  });

  factory ResponseBaseModel.fromJson(Map<String, dynamic> json) {
    return ResponseBaseModel(
      id: json['id'],
      apiVersion: json['apiVersion'],
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['apiVersion'] = apiVersion;
    data['status'] = status;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
