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
          drawer: Drawer(
            backgroundColor: ColoredStatelessWidget.widgetBgColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: ColoredStatelessWidget.appBarBgColor,
                  ),
                  child: Text(
                    'Weather options',
                    style:
                        TextStyle(color: ColoredStatelessWidget.appBarFgColor),
                  ),
                ),
                ListTile(
                  tileColor: ColoredStatelessWidget.widgetListBgColor,
                  title: const Text('Delete...'),
                  onTap: () {
                    context
                        .read<WeatherBloc>()
                        .add(WeatherEventDeletionSelect());
                    Navigator.pop(context);
                  },
                ),
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
      child: Column(
        children: [
          _cityListWidget(context, state),
          _selectionActionWidget(state, context),
        ],
      ),
    );
  }

  Visibility _selectionActionWidget(WeatherState state, BuildContext context) {
    return Visibility(
      visible: state.isDeleting,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () => context
                    .read<WeatherBloc>()
                    .add(WeatherEventDeletionSubmitted()),
                child: const Icon(Icons.delete_forever),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () => context
                    .read<WeatherBloc>()
                    .add(WeatherEventDeletionCancelled()),
                child: const Icon(Icons.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _cityListWidget(BuildContext context, WeatherState state) {
    return Expanded(
      child: Stack(
        children: [
          ReorderableListView.builder(
            padding: const EdgeInsets.all(10.0),
            onReorder: (int oldIndex, int newIndex) =>
                _cityMoved(context, oldIndex, newIndex),
            itemBuilder: (context, index) =>
                _weatherWidget(context, state, state.cities[index], index),
            itemCount: state.cities.length,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _lastUpdatedWidget(context, state),
          ),
        ],
      ),
    );
  }

  void _cityMoved(BuildContext context, int oldIndex, int newIndex) {
    context.read<WeatherBloc>().add(WeatherEventCityMoved(
          oldIndex: oldIndex,
          newIndex: newIndex,
        ));
  }

  Widget _weatherWidget(
    BuildContext context,
    WeatherState state,
    CityWeather cityWeather,
    int index,
  ) {
    return Container(
      key: ObjectKey(index),
      margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      padding: const EdgeInsets.all(8.0),
      color: ColoredStatelessWidget.widgetBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _selectionWidget(state, cityWeather, context, index),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cityNameWidget(cityWeather, context, index),
                _weatherConditionsWidget(cityWeather),
                _errorTextWidget(context, cityWeather),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _weatherConditionsWidget(CityWeather cityWeather) {
    return Row(
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
    );
  }

  Container _cityNameWidget(
    CityWeather cityWeather,
    BuildContext context,
    int index,
  ) {
    return Container(
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
              onPressed: () => _editCity(context, cityWeather.cityName, index),
              child: const Icon(
                Icons.search,
                color: ColoredStatelessWidget.buttonFgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Visibility _selectionWidget(
    WeatherState state,
    CityWeather cityWeather,
    BuildContext context,
    int index,
  ) {
    return Visibility(
      visible: state.isDeleting,
      child: Checkbox(
        value: cityWeather.selected,
        onChanged: (isSelected) {
          context.read<WeatherBloc>().add(WeatherEventCitySelected(
                index: index,
                selected: isSelected ?? false,
              ));
        },
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
