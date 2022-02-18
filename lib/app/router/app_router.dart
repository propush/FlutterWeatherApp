import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/router/error_screen.dart';
import 'package:weather_app/weather/logic/bloc/city_bloc.dart';
import 'package:weather_app/weather/logic/bloc/weather_bloc.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';
import 'package:weather_app/weather/screens/city_screen.dart';
import 'package:weather_app/weather/screens/weather_screen.dart';
import 'package:weather_app/weather/vo/city_arg.dart';

class AppRouter {
  final WeatherBloc weatherBloc;
  final WeatherRepository weatherRepository;

  const AppRouter({
    required this.weatherBloc,
    required this.weatherRepository,
  });

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => weatherBloc,
                  child: WeatherScreen(),
                ));
      case '/city':
        final cityArguments = routeSettings.arguments as CityArguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => CityBloc(
                    cityArguments: cityArguments,
                    weatherRepository: weatherRepository,
                    weatherBloc: weatherBloc,
                  ),
                  child: const CityScreen(),
                ));
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
