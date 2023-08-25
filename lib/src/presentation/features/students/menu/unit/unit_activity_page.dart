import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/assesment_home_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/list_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/students/competences/competences_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/references/references_page.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/list_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/create_self_reflection_page.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/self_reflection_home_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/sgl_cst_home_page.dart';
import 'package:elogbook/src/presentation/features/students/special_reports/special_report_home_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_row.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/list_menu_column.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/menu_switch.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/report_expansion_tile.dart';
import 'package:elogbook/src/presentation/features/students/select_units/select_unit_page.dart';
import 'package:elogbook/src/presentation/widgets/glassmorphism.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';
import 'package:intl/intl.dart';

class UnitActivityPage extends StatefulWidget {
  const UnitActivityPage({super.key});

  @override
  State<UnitActivityPage> createState() => _UnitActivityPageState();
}

class _UnitActivityPageState extends State<UnitActivityPage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<UnitCubit>(context, listen: false)..getActiveUnit());
    _isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();
    _isList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitCubit = context.watch<UnitCubit>().state;
    return CustomScrollView(
      slivers: <Widget>[
        const MainAppBar(),
        SliverFillRemaining(
          child: BlocListener<UnitCubit, UnitState>(
            listener: (context, state) {
              if (state is CheckInActiveUnitSuccess) {
                Future.microtask(
                  () => BlocProvider.of<UnitCubit>(context, listen: false)
                    ..getActiveUnit(),
                );
              }
            },
            child: Builder(builder: (context) {
              if (unitCubit is GetActiveUnitSuccess) {
                final ActiveUnitModel activeUnitModel = unitCubit.activeUnit;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Unit Activity',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Logbook data according to the active unit',
                        style: textTheme.bodyMedium?.copyWith(
                          color: secondaryTextColor,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                  const Text(
                                    'Current Unit',
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    unitCubit.activeUnit.unitName ??
                                        'No Unit Active',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: backgroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  InkWell(
                                    onTap: () {
                                      context.navigateTo(SelectUnitPage(
                                        activeUnitModel: unitCubit.activeUnit,
                                      ));
                                    },
                                    child: Glassmorphism(
                                      blur: 5,
                                      opacity: .15,
                                      radius: 99,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Icon(
                                              Icons.change_circle_outlined,
                                              size: 20,
                                              color: backgroundColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Change Unit',
                                              style: textTheme.labelLarge
                                                  ?.copyWith(
                                                color: backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (activeUnitModel.unitName != null)
                        ReportExpansionTile(
                          isVerified:
                              activeUnitModel.checkInStatus == 'VERIFIED',
                          leadingIcon: Icons.arrow_upward_rounded,
                          leadingColor: variant2Color,
                          title: 'Check In',
                          subtitle: activeUnitModel.checkInStatus == null
                              ? 'Not Submitted yet'
                              : DateFormat('dd, MMM yyyy, HH.mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      activeUnitModel.checkInTime! * 1000),
                                ),
                          children: <Widget>[
                            activeUnitModel.checkInStatus == null
                                ? SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        BlocProvider.of<UnitCubit>(context,
                                            listen: false)
                                          ..checkInActiveUnit();
                                      },
                                      icon: SvgPicture.asset(
                                        AssetPath.getIcon(
                                            'send_alt_filled.svg'),
                                        width: 20,
                                      ),
                                      label: const Text('Send Report'),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: onDisableColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                          'Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color:
                                                successColor.withOpacity(.25),
                                          ),
                                          child: Text(
                                            activeUnitModel.checkInStatus ??
                                                '-',
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: successColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Report time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd, MMM yyyy, HH.mm')
                                              .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                activeUnitModel.checkInTime! *
                                                    1000),
                                          ),
                                          style: textTheme.bodySmall?.copyWith(
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      if (activeUnitModel.checkInStatus == 'VERIFIED')
                        ReportExpansionTile(
                          isVerified:
                              activeUnitModel.checkOutStatus == 'VERIFIED',
                          leadingIcon: Icons.arrow_downward_rounded,
                          leadingColor: successColor,
                          title: 'Check Out',
                          subtitle: activeUnitModel.checkOutStatus == null
                              ? 'Not Submitted yet'
                              : DateFormat('dd, MMM yyyy, HH.mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      activeUnitModel.checkOutTime! * 1000),
                                ),
                          children: <Widget>[
                            activeUnitModel.checkOutStatus == null
                                ? SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        AssetPath.getIcon(
                                            'send_alt_filled.svg'),
                                        width: 20,
                                      ),
                                      label: const Text('Send Report'),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: onDisableColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                          'Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            color:
                                                successColor.withOpacity(.25),
                                          ),
                                          child: Text(
                                            activeUnitModel.checkOutStatus ??
                                                '-',
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: successColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Report time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd, MMM yyyy, HH.mm')
                                              .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                activeUnitModel.checkOutTime! *
                                                    1000),
                                          ),
                                          style: textTheme.bodySmall?.copyWith(
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      // ! Ubah ke VERIFIED setelah integrasi supervior Selesai
                      if (activeUnitModel.checkInStatus == 'VERIFIED') ...[
                        const SizedBox(height: 28),
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
                                reverseDuration:
                                    const Duration(milliseconds: 150),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: isList
                                    ? buildItemList(
                                        activeUnitModel: activeUnitModel,
                                      )
                                    : buildItemGrid(
                                        activeUnitModel: activeUnitModel,
                                      ));
                          },
                        ),
                      ],
                    ],
                  ),
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Column buildItemGrid({required ActiveUnitModel activeUnitModel}) {
    return Column(
      key: const ValueKey(1),
      children: <Widget>[
        GridMenuRow(
          itemColor: primaryColor,
          menus: listStudentMenu.sublist(0, 4),
          onTaps: [
            () => context.navigateTo(
                  SglCstHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  DailyActivityPage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  ListClinicalRecordPage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  StudentListScientificSessionPage(
                      activeUnitModel: activeUnitModel),
                ),
          ],
        ),
        const SizedBox(height: 12),
        GridMenuRow(
          itemColor: variant2Color,
          menus: listStudentMenu.sublist(4, 8),
          onTaps: [
            () => context.navigateTo(
                  StudentSelfReflectionHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  CompetenceHomePage(
                    unitId: activeUnitModel.unitId!,
                    model: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  AssesmentHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  SpecialReportHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
          ],
        ),
        const SizedBox(height: 12),
        GridMenuRow(
          length: 1,
          itemColor: variant1Color,
          menus: listStudentMenu.sublist(8, listStudentMenu.length),
          onTaps: [
            () => context.navigateTo(
                  ReferencePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
          ],
        ),
      ],
    );
  }

  Column buildItemList({required ActiveUnitModel activeUnitModel}) {
    return Column(
      key: const ValueKey(2),
      children: <Widget>[
        ListMenuColumn(
          itemColor: primaryColor,
          menus: listStudentMenu.sublist(0, 4),
          onTaps: [
            () => context.navigateTo(
                  SglCstHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  DailyActivityPage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  ListClinicalRecordPage(activeUnitModel: activeUnitModel),
                ),
            () => StudentListScientificSessionPage(
                activeUnitModel: activeUnitModel),
          ],
        ),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
          itemColor: variant2Color,
          menus: listStudentMenu.sublist(4, 8),
          onTaps: [
            () => context.navigateTo(
                  StudentSelfReflectionHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  CompetenceHomePage(
                    unitId: activeUnitModel.unitId!,
                    model: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  AssesmentHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
            () => context.navigateTo(
                  SpecialReportHomePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
          ],
        ),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
          length: 1,
          itemColor: variant1Color,
          menus: listStudentMenu.sublist(8, 9),
          onTaps: [
            () => context.navigateTo(
                  ReferencePage(
                    activeUnitModel: activeUnitModel,
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
