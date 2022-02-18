import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/app/router/app_router.dart';
import 'package:weather_app/weather/logic/bloc/weather_bloc.dart';
import 'package:weather_app/weather/repository/weather_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());

  HydratedBlocOverrides.runZoned(
    () {
      // final WeatherRepository _weatherRepository = StubWeatherRepository();
      final WeatherRepository _weatherRepository = WeatherRepository();
      final WeatherBloc _weatherBloc = WeatherBloc(
        weatherRepository: _weatherRepository,
      );
      final AppRouter _appRouter = AppRouter(
        weatherBloc: _weatherBloc,
        weatherRepository: _weatherRepository,
      );

      runApp(MyApp(appRouter: _appRouter));
    },
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      onGenerateRoute: appRouter.onGeneratedRoute,
    );
  }
}
