// To parse this JSON data, do
//
//     final updateLocation = updateLocationFromJson(jsonString);

import 'dart:convert';

UpdateLocation updateLocationFromJson(String str) => UpdateLocation.fromJson(json.decode(str));

String updateLocationToJson(UpdateLocation data) => json.encode(data.toJson());

class UpdateLocation {
  UpdateLocation({
    required this.success,
    required this.status,
    required this.message,
  });

  bool success;
  String status;
  String message;

  factory UpdateLocation.fromJson(Map<String, dynamic> json) => UpdateLocation(
    success: json["success"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
  };
}
