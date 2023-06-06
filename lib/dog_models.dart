import 'dart:convert';

DogResponse dogResponseFromJson(String str) => DogResponse.fromJson(json.decode(str));

String dogResponseToJson(DogResponse data) => json.encode(data.toJson());

class DogResponse {
  String message;
  String status;

  DogResponse({
    required this.message,
    required this.status,
  });

  factory DogResponse.fromJson(Map<String, dynamic> json) => DogResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}