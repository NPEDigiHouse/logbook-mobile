import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogbookNoInternet extends StatelessWidget {
  final bool withScaffold;
  final VoidCallback onReload;
  const LogbookNoInternet(
      {super.key, this.withScaffold = false, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(
            backgroundColor: scaffoldBackgroundColor,
            body: content(),
          )
        : content();
  }

  Widget content() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 250,
          child: SvgPicture.asset(
            AssetPath.getVector('no_internet.svg'),
            fit: BoxFit.contain,
          ),
        ),
        const Text(
          'Connection Defused',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Please check your internet connection!',
          maxLines: 3,
          style: TextStyle(
            height: 1,
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        IconButton(
          onPressed: onReload,
          style: IconButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          icon: const Icon(
            Icons.replay_outlined,
            color: scaffoldBackgroundColor,
          ),
        ),
      ],
    ));
  }
}
