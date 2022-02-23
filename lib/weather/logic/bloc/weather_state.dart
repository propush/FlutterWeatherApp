part of 'weather_bloc.dart';

@JsonSerializable(explicitToJson: true)
class CityWeather extends Equatable {
  final String fullLocation;
  final String cityName;
  final String temperature;
  final String conditions;
  final String wind;
  final String icon;
  final String error;
  final bool enabled;
  final bool selected;

  @override
  List<Object> get props => [
        fullLocation,
        cityName,
        temperature,
        conditions,
        wind,
        icon,
        error,
        enabled,
        selected,
      ];

  const CityWeather({
    required this.fullLocation,
    required this.cityName,
    required this.temperature,
    required this.conditions,
    required this.wind,
    required this.icon,
    required this.error,
    this.enabled = true,
    this.selected = false,
  });

  factory CityWeather.fromCurrentWeatherVO(
    String fullLocation,
    bool enabled,
    bool selected,
    CurrentWeatherVO currentWeather,
  ) =>
      CityWeather(
        fullLocation: fullLocation,
        cityName: currentWeather.name,
        temperature: _getTemperature(currentWeather.main.temp),
        conditions: _composeConditions(currentWeather.weatherList),
        wind: _getWind(currentWeather.wind.speed),
        icon: _getIcon(currentWeather.weatherList),
        error: '',
        enabled: enabled,
        selected: selected,
      );

  factory CityWeather.initial() => const CityWeather(
        fullLocation: 'Moscow,ru,Moscow',
        cityName: 'Moscow',
        temperature: 'N/D',
        conditions: 'N/D',
        wind: 'N/D',
        icon: '',
        error: 'Waiting for initialization...',
      );

  static String _getTemperature(double temperatureCelsius) {
    var sign = '';
    var tempInt = temperatureCelsius.floor();
    if (tempInt > 0) {
      sign = '+';
    }
    return '$sign$tempInt C';
  }

  static String _getWind(double speed) => 'Wind: ${speed.floor()} m/s';

  static String _getIcon(List<WeatherVO> weatherList) {
    if (weatherList.isEmpty) {
      return '';
    } else {
      return weatherList.first.icon;
    }
  }

  static String _composeConditions(List<WeatherVO> weatherList) {
    if (weatherList.isEmpty) {
      return '';
    } else {
      var conditions = weatherList.map((e) => e.description).join(', ');
      if (conditions.length > 1) {
        conditions = conditions[0].toUpperCase() + conditions.substring(1);
      } else {
        conditions = conditions.toUpperCase();
      }
      return conditions;
    }
  }

  factory CityWeather.fromJson(Map<String, dynamic> json) =>
      _$CityWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CityWeatherToJson(this);

  CityWeather copyWith({
    String? fullLocation,
    String? cityName,
    String? temperature,
    String? conditions,
    String? wind,
    String? icon,
    String? error,
    bool? enabled,
    bool? selected,
  }) {
    return CityWeather(
      fullLocation: fullLocation ?? this.fullLocation,
      cityName: cityName ?? this.cityName,
      temperature: temperature ?? this.temperature,
      conditions: conditions ?? this.conditions,
      wind: wind ?? this.wind,
      icon: icon ?? this.icon,
      error: error ?? this.error,
      enabled: enabled ?? this.enabled,
      selected: selected ?? this.selected,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class WeatherState extends Equatable {
  final List<CityWeather> cities;
  final DateTime lastUpdated;
  final bool isLoading;
  final bool isDeleting;

  const WeatherState({
    required this.cities,
    required this.lastUpdated,
    required this.isLoading,
    required this.isDeleting,
  });

  @override
  List<Object> get props => [cities, lastUpdated, isLoading, isDeleting];

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  WeatherState copyWith({
    List<CityWeather>? cities,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isDeleting,
  }) {
    return WeatherState(
      cities: cities ?? this.cities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class WeatherInitial extends WeatherState {
  WeatherInitial()
      : super(
          cities: List.from([CityWeather.initial()]),
          lastUpdated: DateTime.fromMicrosecondsSinceEpoch(0),
          isLoading: false,
          isDeleting: false,
        );
}
