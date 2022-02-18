class WeatherErrorFetchingException implements Exception {
  final String message;

  const WeatherErrorFetchingException({
    required this.message,
  });

  @override
  String toString() => message;
}
