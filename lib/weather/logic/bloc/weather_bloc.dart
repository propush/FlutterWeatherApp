import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';
import 'package:weather_app/weather/vo/weather_vo.dart';

part 'weather_bloc.g.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  final Duration _updateFrequency = const Duration(minutes: 60);

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<WeatherEventStartup>((event, emit) => _scheduleUpdates());
    on<WeatherEventUpdateRequested>((event, emit) => _weatherUpdate(emit));
    on<WeatherEventCityUpdated>((event, emit) => _cityUpdate(emit, event));
    on<WeatherEventCityMoved>((event, emit) => _cityMoved(emit, event));
    add(WeatherEventStartup());
  }

  void _scheduleUpdates() {
    if (state.lastUpdated.isBefore(DateTime.now().subtract(_updateFrequency))) {
      add(WeatherEventUpdateRequested());
    }
    Stream.periodic(_updateFrequency, (x) => x).listen((event) {
      add(WeatherEventUpdateRequested());
    });
  }

  Future<void> _weatherUpdate(Emitter<WeatherState> emit) async {
    print("Updating weather");
    emit(state.copyWith(isLoading: true));
    List<CityWeather> updates = List.empty(growable: true);
    for (int i = 0; i < state.cities.length; i++) {
      final cityWeather = state.cities.elementAt(i);
      if (cityWeather.enabled) {
        print("Updating weather for $cityWeather");
        await weatherRepository
            .fetchCurrentWeather(cityWeather.fullLocation)
            .then((currentWeather) {
          updates.add(CityWeather.fromCurrentWeatherVO(
              cityWeather.fullLocation, currentWeather));
        }).onError((error, stackTrace) {
          print("Error on weather update");
          updates.add(cityWeather.copyWith(
              error: 'Error updating weather: ${error?.toString() ?? 'n/a'}'));
        });
      }
    }
    emit(state.copyWith(
        cities: updates, lastUpdated: DateTime.now(), isLoading: false));
    print("Weather update finished");
  }

  _cityUpdate(Emitter<WeatherState> emit, WeatherEventCityUpdated event) {
    if (event.index < 0) {
      _cityAddNew(emit, event);
    } else {
      _cityUpdateExisting(emit, event);
    }
    add(WeatherEventUpdateRequested());
  }

  _cityUpdateExisting(
      Emitter<WeatherState> emit, WeatherEventCityUpdated event) {
    print(
        'Updating city: ${state.cities.elementAt(event.index)} -> ${event.fullLocation}');
    final updated = List<CityWeather>.from(state.cities);
    updated.replaceRange(
      event.index,
      event.index + 1,
      [
        CityWeather.initial().copyWith(
          fullLocation: event.fullLocation,
          cityName: event.cityName,
        )
      ],
    );
    emit(state.copyWith(cities: updated));
  }

  _cityAddNew(Emitter<WeatherState> emit, WeatherEventCityUpdated event) {
    print('Adding new city: ${event.fullLocation}');
    final updated = List<CityWeather>.from(state.cities);
    updated.add(CityWeather.initial()
        .copyWith(fullLocation: event.fullLocation, cityName: event.cityName));
    emit(state.copyWith(cities: updated));
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WeatherState state) => state.toJson();

  _cityMoved(Emitter<WeatherState> emit, WeatherEventCityMoved event) {
    print('Moving city from ${event.oldIndex} to ${event.newIndex}');

    // Check if we need index correction due to strange behaviour of the widget
    var correctedIndex = event.newIndex;
    if (correctedIndex > event.oldIndex) {
      correctedIndex--;
    }
    emit(state.copyWith(
        cities: _swapListItems(state.cities, event.oldIndex, correctedIndex)));
  }

  List<CityWeather> _swapListItems(
      List<CityWeather> cities, int oldIndex, int newIndex) {
    final newList = List.of(cities);
    final element = newList.removeAt(oldIndex);
    newList.insert(newIndex, element);
    return newList;
  }
}
