import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/base/widgets/colored_stateless_widget.dart';
import 'package:weather_app/base/widgets/loading_widget.dart';
import 'package:weather_app/weather/logic/bloc/city_bloc.dart';
import 'package:weather_app/weather/vo/city_vo.dart';

class CityScreen extends ColoredStatelessWidget {
  const CityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('City edit'),
                LoadingWidget(isLoading: state.updating),
              ],
            ),
            backgroundColor: ColoredStatelessWidget.appBarBgColor,
            foregroundColor: ColoredStatelessWidget.appBarFgColor,
          ),
          body: Container(
            color: ColoredStatelessWidget.widgetListBgColor,
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _locationTextFormFieldWidget(state, context),
                  _locationListWidget(state, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _locationTextFormFieldWidget(CityState state, BuildContext context) {
    return TextFormField(
      initialValue: state.location,
      onChanged: (value) => context
          .read<CityBloc>()
          .add(CityEventFullLocationUpdated(location: value)),
    );
  }

  Widget _locationListWidget(CityState state, BuildContext context) {
    return Container(
      color: ColoredStatelessWidget.widgetListBgColor,
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: state.cityVOList.length,
        itemBuilder: (context, index) => _locationWidget(state, context, index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _locationWidget(CityState state, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        context.read<CityBloc>().add(CityEventFullLocationSubmitted(
              location: _composeFullLocation(state.cityVOList[index]),
              cityName: state.cityVOList[index].name,
            ));
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: ColoredStatelessWidget.widgetBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${state.cityVOList[index].name}',
              style: const TextStyle(
                color: ColoredStatelessWidget.textFgColor,
              ),
            ),
            Text(
              'Country: ${state.cityVOList[index].country}',
              style: const TextStyle(
                color: ColoredStatelessWidget.textFgColor,
              ),
            ),
            Text(
              'State: ${state.cityVOList[index].state}',
              style: const TextStyle(
                color: ColoredStatelessWidget.textFgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _composeFullLocation(CityVO cityVO) =>
      '${cityVO.name},${cityVO.country},${cityVO.state}';
}
