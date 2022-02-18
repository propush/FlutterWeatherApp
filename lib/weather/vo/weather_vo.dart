import 'package:json_annotation/json_annotation.dart';

part 'weather_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherVO {
  final String main;
  final String description;
  final String icon;

  const WeatherVO({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherVO.fromJson(Map<String, dynamic> json) =>
      _$WeatherVOFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MainVO {
  final double temp;

  const MainVO({
    required this.temp,
  });

  factory MainVO.fromJson(Map<String, dynamic> json) => _$MainVOFromJson(json);

  Map<String, dynamic> toJson() => _$MainVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WindVO {
  final double speed;
  final int deg;

  const WindVO({
    required this.speed,
    required this.deg,
  });

  factory WindVO.fromJson(Map<String, dynamic> json) => _$WindVOFromJson(json);

  Map<String, dynamic> toJson() => _$WindVOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CurrentWeatherVO {
  @JsonKey(name: 'weather')
  final List<WeatherVO> weatherList;
  final MainVO main;
  final WindVO wind;
  final String name;

  const CurrentWeatherVO({
    required this.weatherList,
    required this.main,
    required this.wind,
    required this.name,
  });

  factory CurrentWeatherVO.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherVOFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherVOToJson(this);
}
