import 'package:json_annotation/json_annotation.dart';

part 'city_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class CityVO {
  final String name;
  final String country;
  final String state;

  const CityVO({
    required this.name,
    required this.country,
    required this.state,
  });

  factory CityVO.fromJson(Map<String, dynamic> json) => _$CityVOFromJson(json);

  Map<String, dynamic> toJson() => _$CityVOToJson(this);
}
