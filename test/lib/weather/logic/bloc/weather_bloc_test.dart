import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/weather/logic/bloc/weather_bloc.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';
import 'package:weather_app/weather/vo/weather_vo.dart';

import '../../../utility/mock_storage.dart';
import 'weather_bloc_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  late WeatherRepository _weatherRepository;
  late WeatherBloc _weatherBloc;

  group('Positive weather bloc tests', () {
    setUp(() async {
      _weatherRepository = MockWeatherRepository();
      when(_weatherRepository.fetchCurrentWeather('Moscow,ru,Moscow'))
          .thenAnswer((_) => Future.value(CurrentWeatherVO.fromJson(jsonDecode(
              '{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":280.34,"feels_like":275.45,"temp_min":278.87,"temp_max":281.21,"pressure":1000,"humidity":51},"visibility":10000,"wind":{"speed":10.8,"deg":260,"gust":18.52},"clouds":{"all":68},"dt":1645205783,"sys":{"type":2,"id":2019646,"country":"GB","sunrise":1645168144,"sunset":1645204807},"timezone":0,"id":2643743,"name":"Moscow","cod":200}'))));
    });

    blocTest<WeatherBloc, WeatherState>(
      'Fetch weather on start',
      setUp: () async =>
          _weatherBloc = await _getWeatherBloc(_weatherRepository),
      build: () => _weatherBloc,
      expect: () => [
        isA<WeatherState>()
            .having((state) => state.isLoading, 'isLoading', true)
            .having((state) => state.cities.first.temperature,
                'cities.first.temperature', 'N/D')
            .having((state) => state.cities.first.cityName,
                'cities.first.cityName', 'Moscow'),
        isA<WeatherState>()
            .having((state) => state.isLoading, 'isLoading', false)
            .having((state) => state.cities.first.temperature,
                'cities.first.temperature', '+280 C')
            .having((state) => state.cities.first.cityName,
                'cities.first.cityName', 'Moscow'),
      ],
      verify: (bloc) {
        verify(_weatherRepository.fetchCurrentWeather('Moscow,ru,Moscow'))
            .called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'Don' 't fetch weather on start if last updated recently',
      setUp: () async => _weatherBloc = await _getWeatherBloc(
          _weatherRepository,
          storage: _MockStorageWeatherRecentlyUpdated()),
      build: () => _weatherBloc,
      expect: () => [],
      verify: (bloc) {
        verifyZeroInteractions(_weatherRepository);
      },
    );
  });
}

class _MockStorageWeatherRecentlyUpdated extends Mock implements Storage {
  @override
  dynamic read(String key) {
    if (key == 'WeatherBloc') {
      return WeatherInitial()
          .copyWith(
              lastUpdated: DateTime.now().subtract(const Duration(seconds: 1)))
          .toJson();
    }
  }
}

Future<WeatherBloc> _getWeatherBloc(WeatherRepository weatherRepository,
    {Storage? storage}) async {
  late WeatherBloc weatherBloc;
  await mockHydratedStorage(
    () async {
      weatherBloc = WeatherBloc(weatherRepository: weatherRepository);
    },
    storage: storage,
  );
  return weatherBloc;
}
