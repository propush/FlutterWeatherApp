import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WeatherPictureImage extends StatelessWidget {
  static const imageUrl = 'https://openweathermap.org/img/wn/';
  static const imageExt = '.png';
  final String cityWeatherIcon;

  const WeatherPictureImage({Key? key, required this.cityWeatherIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cityWeatherIcon.isEmpty) {
      return const Icon(Icons.cancel);
    } else {
      return CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: '$imageUrl$cityWeatherIcon$imageExt',
      );
    }
  }
}
