import 'dart:io';

import 'package:algooceantask/dog_models.dart';
import 'package:http/http.dart' as http;
class ApiHandler {

  static final shared = ApiHandler();

  static final ApiHandler _instance = ApiHandler._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._internal() {
    // initialization logic
  }

Future<DogResponse> getDogData(String apiName) async {
  http.Response responseJson;
  DogResponse dogResponse;
try{
  var uri = Uri.parse(apiName);
  final response = await http.get(uri);
  responseJson =_response(response);
  String body = responseJson.body;
  dogResponse = dogResponseFromJson(body);
}on SocketException {
  throw throw FetchDataException('No Internet connection');
}
    return dogResponse;
}


}

http.Response _response(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode');
  }
}


class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}