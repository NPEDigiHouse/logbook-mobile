import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/datasources/local_datasources/static_datasource.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/grid_menu_row.dart';
import 'package:main/widgets/list_menu_column.dart';
import 'package:main/widgets/main_app_bar.dart';
import 'package:main/widgets/menu_switch.dart';

import '../../assesment/assesment_list_student_page.dart';
import '../../clinical_record/list_clinical_record_page.dart';
import '../../competence/supervisor_competence_page.dart';
import '../../daily_activity/supervisor_list_daily_activity_page.dart';
import '../../final_score/supervisor_list_student_unit_page.dart';
import '../../scientific_session/list_scientific_session_page.dart';
import '../../self_reflection/list_self_reflection_page.dart';
import '../../sgl_cst/supervisor_sgl_cst_page.dart';
import '../../special_report/list_report_student_page.dart';
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
    BlocProvider.of<UserCubit>(context).getProfilePic();

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
        const MainAppBar(
          withLogout: false,
        ),
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
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('half_ellipse.svg'),
                          color: secondaryColor,
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
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Let\'s Complete Some Tasks To Help Students',
                              style: TextStyle(color: backgroundColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
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
              () => context.navigateTo(SupervisorSglCstHomePage(
                    credential: widget.credential,
                  )),
              () => context
                  .navigateTo(const SupervisorStudentsDailyActivityPage()),
              () => context.navigateTo(const SupervisorListClinicalRecord()),
              () => context
                  .navigateTo(const SupervisorListScientificSessionPage()),
            ]),
        const SizedBox(height: 12),
        GridMenuRow(
            itemColor: variant2Color,
            menus: listSupervisorMenu.sublist(4, 8),
            onTaps: [
              () =>
                  context.navigateTo(const SupervisorListSelfReflectionsPage()),
              () => context.navigateTo(const SupervisorCompetenceHomePage()),
              () => context.navigateTo(SupervisorAssesmentStudentPage(
                    credential: widget.credential,
                  )),
              () => context.navigateTo(const SupervisorListSpecialReportPage()),
            ]),
        if (widget.credential.badges!
                .indexWhere((element) => element.name == 'CEU') !=
            -1) ...[
          const SizedBox(height: 12),
          GridMenuRow(
              itemColor: variant1Color,
              length: 1,
              menus: listSupervisorMenu.sublist(8, listSupervisorMenu.length),
              onTaps: [
                () => context
                    .navigateTo(const SupervisorListStudentDepartmentPage()),
              ]),
        ],
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
            () => context.navigateTo(SupervisorSglCstHomePage(
                  credential: widget.credential,
                )),
            () =>
                context.navigateTo(const SupervisorStudentsDailyActivityPage()),
            () => context.navigateTo(const SupervisorListClinicalRecord()),
            () =>
                context.navigateTo(const SupervisorListScientificSessionPage()),
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
            () => context.navigateTo(const SupervisorListSelfReflectionsPage()),
            () => context.navigateTo(const SupervisorCompetenceHomePage()),
            () => context.navigateTo(SupervisorAssesmentStudentPage(
                  credential: widget.credential,
                )),
            () => context.navigateTo(const SupervisorListSpecialReportPage()),
          ],
        ),
        if (widget.credential.badges!
                .indexWhere((element) => element.name == 'CEU') !=
            -1) ...[
          const Divider(
            height: 30,
            thickness: 1,
            color: Color(0xFFEFF0F9),
          ),
          ListMenuColumn(
            itemColor: variant1Color,
            length: 1,
            menus: listSupervisorMenu.sublist(8, listSupervisorMenu.length),
            onTaps: [
              () => context
                  .navigateTo(const SupervisorListStudentDepartmentPage()),
            ],
          ),
        ],
      ],
    );
  }
}
