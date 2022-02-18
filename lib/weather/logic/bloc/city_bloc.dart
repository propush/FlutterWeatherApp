import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather_app/weather/logic/bloc/weather_bloc.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';
import 'package:weather_app/weather/vo/city_arg.dart';
import 'package:weather_app/weather/vo/city_vo.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final WeatherRepository weatherRepository;
  final CityArguments cityArguments;
  final WeatherBloc weatherBloc;

  CityBloc({
    required this.weatherRepository,
    required this.cityArguments,
    required this.weatherBloc,
  }) : super(CityState(
          location: cityArguments.cityName,
          cityVOList: List<CityVO>.empty(),
          weatherCityIndex: cityArguments.index,
          updating: true,
        )) {
    on<CityEventFullLocationUpdated>(
      (event, emit) async {
        emit(state.copyWith(location: event.location, updating: true));
        await _updateCityList(state.location);
      },
      transformer: _debounce,
    );
    on<CityEventCityListUpdated>((event, emit) =>
        emit(state.copyWith(cityVOList: event.cityVOList, updating: false)));
    on<CityEventFullLocationSubmitted>(
        (event, emit) => _locationSubmitted(event));
    on<CityEventUpdateFailed>((event, emit) => emit(state.copyWith(
        cityVOList: List<CityVO>.empty(),
        updating: false,
        error: event.error)));

    _updateCityList(state.location);
  }

  Stream<CityEventFullLocationUpdated> _debounce(
      Stream<CityEventFullLocationUpdated> events,
      Stream<CityEventFullLocationUpdated> Function(
              CityEventFullLocationUpdated)
          mapper) {
    return events
        .debounce(const Duration(seconds: 3), leading: false)
        .switchMap(mapper);
  }

  Future<void> _updateCityList(String location) async {
    print('_updateCityList($location) called');
    weatherRepository
        .fetchLocations(location)
        .then((value) => add(CityEventCityListUpdated(cityVOList: value)))
        .onError((error, stackTrace) => add(
              CityEventUpdateFailed(
                error:
                    'Error updating city list: ${error?.toString() ?? 'N/A'}',
              ),
            ));
  }

  void _locationSubmitted(CityEventFullLocationSubmitted event) {
    weatherBloc.add(WeatherEventCityUpdated(
      fullLocation: event.location,
      cityName: event.cityName,
      index: state.weatherCityIndex,
    ));
  }
}
