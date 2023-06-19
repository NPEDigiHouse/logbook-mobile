import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      title: const Text('E-Logbook'),
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SvgPicture.asset(
          AssetPath.getVector('logo.svg'),
        ),
      ),
      leadingWidth: 56,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () async {
              await BlocProvider.of<AuthCubit>(context).logout();
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: primaryColor,
              size: 30,
            ),
            tooltip: 'Keluar',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE8E4E4),
        ),
      ),
    );
  }
}
