import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_row.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/list_menu_column.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/menu_switch.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/list_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/supervisor_competence_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/list_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/list_self_reflection_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/supervisor_sgl_cst_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/special_report/supervisor_special_report_page.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorMenuPage extends StatefulWidget {
  final UserCredential credential;

  const SupervisorMenuPage({super.key, required this.credential});

  @override
  State<SupervisorMenuPage> createState() => _SupervisorMenuPageState();
}

class _SupervisorMenuPageState extends State<SupervisorMenuPage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context)..getProfilePic();

    _isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    _isList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.credential.fullname);
    return CustomScrollView(
      slivers: <Widget>[
        const MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: AppSize.getAppWidth(context) - 46,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: const Offset(6, 8),
                        color: primaryColor.withOpacity(.3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                          child: SvgPicture.asset(
                            AssetPath.getVector('ellipse_1.svg'),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('half_ellipse.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hello, ${widget.credential.fullname}',
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Let\'s Complete Some Tasks To Help Students',
                              style: TextStyle(color: backgroundColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return MenuSwitch(
                      value: isList,
                      onToggle: (value) => _isList.value = value,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        reverseDuration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isList ? buildItemList() : buildItemGrid());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildItemGrid() {
    return Column(
      key: const ValueKey(1),
      children: <Widget>[
        GridMenuRow(
            itemColor: primaryColor,
            menus: listSupervisorMenu.sublist(0, 4),
            onTaps: [
              () => context.navigateTo(SupervisorSglCstPage()),
              () => context.navigateTo(SupervisorDailyActivityHomePage()),
              () => context.navigateTo(SupervisorListClinicalRecord()),
              () => context.navigateTo(SupervisorListScientificSessionPage()),
            ]),
        const SizedBox(height: 12),
        GridMenuRow(
            itemColor: variant2Color,
            menus: listSupervisorMenu.sublist(4, 8),
            onTaps: [
              () => context.navigateTo(SupervisorListSelfReflectionsPage()),
              () => context.navigateTo(SupervisorCompetencePage()),
              () => context.navigateTo(SupervisorCompetencePage()),
              () => context.navigateTo(SupervisorSpecialReportPage()),
            ]),
      ],
    );
  }

  Column buildItemList() {
    return Column(
      key: const ValueKey(2),
      children: <Widget>[
        ListMenuColumn(
          itemColor: primaryColor,
          menus: listSupervisorMenu.sublist(0, 4),
          onTaps: [
            () => context.navigateTo(SupervisorSglCstPage()),
            () => context.navigateTo(SupervisorDailyActivityHomePage()),
            () => context.navigateTo(SupervisorListClinicalRecord()),
            () => context.navigateTo(SupervisorListScientificSessionPage()),
          ],
        ),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
          itemColor: variant2Color,
          menus: listSupervisorMenu.sublist(4, 8),
          onTaps: [
            () => context.navigateTo(SupervisorListSelfReflectionsPage()),
            () => context.navigateTo(SupervisorCompetencePage()),
            () => context.navigateTo(SupervisorCompetencePage()),
            () => context.navigateTo(SupervisorSpecialReportPage()),
          ],
        ),
      ],
    );
  }
}
