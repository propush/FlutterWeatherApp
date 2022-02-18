import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;

  const LoadingWidget({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LoadingWidget, isLoading = $isLoading');
    return Visibility(
      key: ObjectKey(isLoading),
      child: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: const CircularProgressIndicator(),
      ),
      visible: isLoading,
    );
  }
}
