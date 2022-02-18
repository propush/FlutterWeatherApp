import 'dart:collection';

import 'package:http/http.dart';

class BaseNetworkRepository {
  static const baseUrl = 'https://api.openweathermap.org/';
  static const apiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: 'wrong key',
  );

  final HashMap<String, String> headers = HashMap.of({
    'Content-type': 'application/json',
    'Accept': 'application/json',
  });

  final client = Client();

  BaseNetworkRepository();

  BaseNetworkRepository.withHeaders({required additionalHeaders}) {
    headers.addAll(additionalHeaders);
  }

  void setHeader(String header, String? value) {
    headers.remove(header);
    if (value != null) {
      headers[header] = value;
    }
  }

  void checkResponse(Response response,
      {required void Function(Response) onError}) {
    if (response.statusCode != 200) {
      onError(response);
    }
  }

  void checkResponseOrThrow(Response response, Exception Function() exception) {
    if (response.statusCode != 200) {
      throw exception.call();
    }
  }
}
