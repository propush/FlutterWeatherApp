part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class CityEventCityListUpdated extends CityEvent {
  final List<CityVO> cityVOList;

  const CityEventCityListUpdated({
    required this.cityVOList,
  });

  @override
  List<Object> get props => [cityVOList];
}

class CityEventFullLocationUpdated extends CityEvent {
  final String location;

  const CityEventFullLocationUpdated({
    required this.location,
  });

  @override
  List<Object> get props => [location];
}

class CityEventUpdateFailed extends CityEvent {
  final String error;

  const CityEventUpdateFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class CityEventFullLocationSubmitted extends CityEvent {
  final String location;
  final String cityName;

  const CityEventFullLocationSubmitted({
    required this.location,
    required this.cityName,
  });

  @override
  List<Object> get props => [location, cityName];
}
