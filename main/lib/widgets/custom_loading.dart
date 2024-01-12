// ignore_for_file: library_private_types_in_public_api

import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(.5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: secondaryColor.withOpacity(.3),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                  spreadRadius: 3)
            ]),
        padding: const EdgeInsets.all(20),
        child: RotationTransition(
          turns: _controller,
          child: SvgPicture.asset(
            AssetPath.getIcon('logo.svg'),
            color: scaffoldBackgroundColor,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
