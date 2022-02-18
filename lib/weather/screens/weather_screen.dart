import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/base/widgets/colored_stateless_widget.dart';
import 'package:weather_app/base/widgets/loading_widget.dart';
import 'package:weather_app/base/widgets/weather_picture_image.dart';
import 'package:weather_app/weather/logic/bloc/weather_bloc.dart';
import 'package:weather_app/weather/vo/city_arg.dart';

class WeatherScreen extends ColoredStatelessWidget {
  final DateFormat df = DateFormat.yMMMMd().add_Hms();

  WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColoredStatelessWidget.appBarBgColor,
            foregroundColor: ColoredStatelessWidget.appBarFgColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Weather app"),
                LoadingWidget(isLoading: state.isLoading),
              ],
            ),
          ),
          body: _weatherWidgets(context, state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColoredStatelessWidget.buttonBgColor,
            child: const Icon(
              Icons.add,
              color: ColoredStatelessWidget.buttonFgColor,
            ),
            onPressed: () => _addCity(context),
          ),
        );
      },
    );
  }

  Widget _weatherWidgets(BuildContext context, WeatherState state) {
    return Container(
      color: ColoredStatelessWidget.widgetListBgColor,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(10.0),
            itemCount: state.cities.length,
            itemBuilder: (context, index) => _weatherWidget(
                context, state, state.cities.elementAt(index), index),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _lastUpdatedWidget(context, state),
          ),
        ],
      ),
    );
  }

  Widget _weatherWidget(
    BuildContext context,
    WeatherState state,
    CityWeather cityWeather,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ColoredStatelessWidget.widgetBgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColoredStatelessWidget.buttonBgColor,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    cityWeather.cityName,
                    style: const TextStyle(
                        fontSize: 30.0,
                        color: ColoredStatelessWidget.cityFgColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColoredStatelessWidget.buttonBgColor),
                    onPressed: () =>
                        _editCity(context, cityWeather.cityName, index),
                    child: const Icon(
                      Icons.search,
                      color: ColoredStatelessWidget.buttonFgColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  cityWeather.temperature,
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: ColoredStatelessWidget.textFgColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityWeather.conditions,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: ColoredStatelessWidget.textFgColor,
                        ),
                      ),
                      Text(
                        cityWeather.wind,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: ColoredStatelessWidget.textFgColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 6.0, top: 10.0),
                child: Container(
                  color: ColoredStatelessWidget.appBarBgColor,
                  child: WeatherPictureImage(cityWeatherIcon: cityWeather.icon),
                ),
              ),
            ],
          ),
          _errorTextWidget(context, cityWeather),
        ],
      ),
    );
  }

  Widget _errorTextWidget(BuildContext context, CityWeather cityWeather) {
    return Visibility(
      visible: cityWeather.error.isNotEmpty,
      child: Text(
        cityWeather.error,
        style: const TextStyle(color: ColoredStatelessWidget.errorTextFgColor),
      ),
    );
  }

  Widget _lastUpdatedWidget(BuildContext context, WeatherState state) {
    return Text(
      'Last updated: ${df.format(state.lastUpdated)}',
      style: const TextStyle(color: ColoredStatelessWidget.textFgColor),
    );
  }

  _editCity(BuildContext context, String cityName, int index) {
    Navigator.of(context).pushNamed(
      '/city',
      arguments: CityArguments(cityName: cityName, index: index),
    );
  }

  _addCity(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/city',
      arguments: const CityArguments(cityName: '', index: -1),
    );
  }
}
