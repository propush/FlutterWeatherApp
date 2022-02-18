// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherVO _$WeatherVOFromJson(Map<String, dynamic> json) => WeatherVO(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherVOToJson(WeatherVO instance) => <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

MainVO _$MainVOFromJson(Map<String, dynamic> json) => MainVO(
      temp: (json['temp'] as num).toDouble(),
    );

Map<String, dynamic> _$MainVOToJson(MainVO instance) => <String, dynamic>{
      'temp': instance.temp,
    };

WindVO _$WindVOFromJson(Map<String, dynamic> json) => WindVO(
      speed: (json['speed'] as num).toDouble(),
      deg: json['deg'] as int,
    );

Map<String, dynamic> _$WindVOToJson(WindVO instance) => <String, dynamic>{
      'speed': instance.speed,
      'deg': instance.deg,
    };

CurrentWeatherVO _$CurrentWeatherVOFromJson(Map<String, dynamic> json) =>
    CurrentWeatherVO(
      weatherList: (json['weather'] as List<dynamic>)
          .map((e) => WeatherVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      main: MainVO.fromJson(json['main'] as Map<String, dynamic>),
      wind: WindVO.fromJson(json['wind'] as Map<String, dynamic>),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CurrentWeatherVOToJson(CurrentWeatherVO instance) =>
    <String, dynamic>{
      'weather': instance.weatherList.map((e) => e.toJson()).toList(),
      'main': instance.main.toJson(),
      'wind': instance.wind.toJson(),
      'name': instance.name,
    };
