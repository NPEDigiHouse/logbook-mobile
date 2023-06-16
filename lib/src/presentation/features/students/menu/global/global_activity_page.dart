import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/global/global_data.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_item.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/list_menu_item.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/menu_switch.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';

class GlobalActivityPage extends StatefulWidget {
  const GlobalActivityPage({super.key});

  @override
  State<GlobalActivityPage> createState() => _GlobalActivityPageState();
}

class _GlobalActivityPageState extends State<GlobalActivityPage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();

    _isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    _isList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(99),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: const Offset(8, 8),
                        color: primaryColor.withOpacity(.3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('circle_bg1.svg'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('half_ellipse2.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Log\nGlobal Activity',
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 32,
                                color: scaffoldBackgroundColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lorem ipsum dolor sit amet consectetur',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: backgroundColor,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MenuSwitch(
                        value: isList,
                        onToggle: (value) => _isList.value = value,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        reverseDuration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isList ? buildItemList() : buildItemGrid(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GridView buildItemGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return GridMenuItem(
          color: colors[index],
          iconPath: iconPaths[index],
          label: labels[index],
          onTap: onTaps[index],
        );
      },
      itemCount: labels.length,
    );
  }

  ListView buildItemList() {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListMenuItem(
          color: colors[index],
          iconPath: iconPaths[index],
          label: labels[index],
          description: descriptions[index],
          onTap: onTaps[index],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        );
      },
      itemCount: labels.length,
    );
  }
}
