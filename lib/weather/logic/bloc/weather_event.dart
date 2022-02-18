part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherEventStartup extends WeatherEvent {}

class WeatherEventUpdateRequested extends WeatherEvent {}

class WeatherEventCityUpdated extends WeatherEvent {
  final String fullLocation;
  final String cityName;
  final int index;

  const WeatherEventCityUpdated({
    required this.fullLocation,
    required this.cityName,
    required this.index,
  });

  @override
  List<Object> get props => [fullLocation, cityName, index];
}
