import 'package:core/styles/color_palette.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingGrid(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? primaryColor : secondaryColor,
          ),
        );
      },
    );
    return Center(
      child: spinkit,
    );
  }
}
