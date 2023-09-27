import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
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
        Text(
          'Koneksi Terputus',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Harap periksa sambungan internet anda',
          maxLines: 3,
          style: TextStyle(
            height: 1,
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        IconButton(
          onPressed: onReload,
          style: IconButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          icon: Icon(
            Icons.replay_outlined,
            color: scaffoldBackgroundColor,
          ),
        ),
      ],
    ));
  }
}
