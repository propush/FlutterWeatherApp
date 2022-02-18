import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';

void main() {
  late WeatherRepository _weatherRepository;

  group('Weather repository tests', () {
    setUp(() {
      _weatherRepository = WeatherRepository();
    });
    test('Fetch weather for Moscow,ru city', () async {
      final currentWeather =
          await _weatherRepository.fetchCurrentWeather('Moscow,ru');
      print('Weather fetched: ${currentWeather.toJson()}');
      assert(currentWeather.name == 'Moscow');
    });
  });
}
