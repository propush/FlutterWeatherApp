part of 'city_bloc.dart';

class CityState extends Equatable {
  final String location;
  final List<CityVO> cityVOList;
  final int weatherCityIndex;
  final bool updating;
  final String error;

  const CityState({
    required this.location,
    required this.cityVOList,
    required this.weatherCityIndex,
    required this.updating,
    this.error = '',
  });

  @override
  List<Object> get props =>
      [location, cityVOList, weatherCityIndex, updating, error];

  CityState copyWith({
    String? location,
    List<CityVO>? cityVOList,
    int? weatherCityIndex,
    bool? updating,
    String? error,
  }) {
    return CityState(
      location: location ?? this.location,
      cityVOList: cityVOList ?? this.cityVOList,
      weatherCityIndex: weatherCityIndex ?? this.weatherCityIndex,
      updating: updating ?? this.updating,
      error: error ?? this.error,
    );
  }
}
