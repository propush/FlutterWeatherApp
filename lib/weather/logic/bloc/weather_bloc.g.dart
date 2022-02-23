// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityWeather _$CityWeatherFromJson(Map<String, dynamic> json) => CityWeather(
      fullLocation: json['fullLocation'] as String,
      cityName: json['cityName'] as String,
      temperature: json['temperature'] as String,
      conditions: json['conditions'] as String,
      wind: json['wind'] as String,
      icon: json['icon'] as String,
      error: json['error'] as String,
      enabled: json['enabled'] as bool? ?? true,
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$CityWeatherToJson(CityWeather instance) =>
    <String, dynamic>{
      'fullLocation': instance.fullLocation,
      'cityName': instance.cityName,
      'temperature': instance.temperature,
      'conditions': instance.conditions,
      'wind': instance.wind,
      'icon': instance.icon,
      'error': instance.error,
      'enabled': instance.enabled,
      'selected': instance.selected,
    };

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) => WeatherState(
      cities: (json['cities'] as List<dynamic>)
          .map((e) => CityWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isLoading: json['isLoading'] as bool,
      isDeleting: json['isDeleting'] as bool,
    );

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'cities': instance.cities.map((e) => e.toJson()).toList(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isLoading': instance.isLoading,
      'isDeleting': instance.isDeleting,
    };
