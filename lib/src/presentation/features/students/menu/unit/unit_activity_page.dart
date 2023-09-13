import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/assesment_home_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/list_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/students/competences/competences_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/references/references_page.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/list_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/self_reflection_home_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/sgl_cst_home_page.dart';
import 'package:elogbook/src/presentation/features/students/special_reports/special_report_home_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
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

class DepartmentActivityPage extends StatefulWidget {
  final UserCredential credential;
  const DepartmentActivityPage({super.key, required this.credential});

  @override
  State<DepartmentActivityPage> createState() => _DepartmentActivityPageState();
}

class _DepartmentActivityPageState extends State<DepartmentActivityPage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<DepartmentCubit>(context, listen: false)
          ..getActiveDepartment());
    _isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();
    _isList.dispose();
  }

  List<VoidCallback> onTaps(ActiveDepartmentModel activeDepartmentModel) => [
        () => context.navigateTo(
              SglCstHomePage(
                  activeDepartmentModel: activeDepartmentModel,
                  isCstHide: (activeDepartmentModel.unitName!
                          .toUpperCase()
                          .contains('FORENSIK') ||
                      activeDepartmentModel.unitName?.toUpperCase() ==
                          'IKM-IKK')),
            ),
        () => context.navigateTo(
              DailyActivityPage(
                activeDepartmentModel: activeDepartmentModel,
              ),
            ),
        () => context.navigateTo(
              ListClinicalRecordPage(
                activeDepartmentModel: activeDepartmentModel,
              ),
            ),
        () => context.navigateTo(
              StudentListScientificSessionPage(
                  activeDepartmentModel: activeDepartmentModel),
            ),
        () => context.navigateTo(
              StudentSelfReflectionHomePage(
                activeDepartmentModel: activeDepartmentModel,
                credential: widget.credential,
              ),
            ),
        () => context.navigateTo(
              CompetenceHomePage(
                unitId: activeDepartmentModel.unitId!,
                model: activeDepartmentModel,
              ),
            ),
        () => context.navigateTo(
              AssesmentHomePage(
                activeDepartmentModel: activeDepartmentModel,
                credential: widget.credential,
              ),
            ),
        () => context.navigateTo(
              SpecialReportHomePage(
                activeDepartmentModel: activeDepartmentModel,
                credential: widget.credential,
              ),
            ),
        () => context.navigateTo(
              ReferencePage(
                activeDepartmentModel: activeDepartmentModel,
              ),
            ),
      ];

  @override
  Widget build(BuildContext context) {
    final unitCubit = context.watch<DepartmentCubit>().state;
    return RefreshIndicator(
      onRefresh: () => Future.wait([
        Future.microtask(() =>
            BlocProvider.of<DepartmentCubit>(context, listen: false)
              ..getActiveDepartment())
      ]),
      child: CustomScrollView(
        slivers: <Widget>[
          const MainAppBar(
            withLogout: false,
          ),
          SliverFillRemaining(
            child: BlocListener<DepartmentCubit, DepartmentState>(
              listener: (context, state) {
                if (state is CheckInActiveDepartmentSuccess ||
                    state is CheckOutActiveDepartmentSuccess) {
                  Future.microtask(
                    () =>
                        BlocProvider.of<DepartmentCubit>(context, listen: false)
                          ..getActiveDepartment(),
                  );
                }
              },
              child: Builder(builder: (context) {
                if (unitCubit is GetActiveDepartmentSuccess) {
                  final ActiveDepartmentModel activeDepartmentModel =
                      unitCubit.activeDepartment;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Department Activity',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
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
                                      'Current Department',
                                      style: TextStyle(color: backgroundColor),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      unitCubit.activeDepartment.unitName ??
                                          'No Department Active',
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
                                        context.navigateTo(SelectDepartmentPage(
                                          activeDepartmentModel:
                                              unitCubit.activeDepartment,
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
                                                'Change Department',
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
                        if (activeDepartmentModel.unitName != null)
                          ReportExpansionTile(
                            isVerified: activeDepartmentModel.checkInStatus ==
                                'VERIFIED',
                            leadingIcon: Icons.arrow_upward_rounded,
                            leadingColor: variant2Color,
                            title: 'Check In',
                            subtitle:
                                activeDepartmentModel.checkInStatus == null
                                    ? 'Not Submitted yet'
                                    : DateFormat('dd, MMM yyyy, HH.mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            activeDepartmentModel.checkInTime! *
                                                1000),
                                      ),
                            children: <Widget>[
                              activeDepartmentModel.checkInStatus == null
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          BlocProvider.of<DepartmentCubit>(
                                              context,
                                              listen: false)
                                            ..checkInActiveDepartment();
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
                                              activeDepartmentModel
                                                      .checkInStatus ??
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
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      activeDepartmentModel
                                                              .checkInTime! *
                                                          1000),
                                            ),
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        if (activeDepartmentModel.checkInStatus == 'VERIFIED')
                          ReportExpansionTile(
                            isVerified: activeDepartmentModel.checkOutStatus ==
                                'VERIFIED',
                            leadingIcon: Icons.arrow_downward_rounded,
                            leadingColor: successColor,
                            title: 'Check Out',
                            subtitle: activeDepartmentModel.checkOutStatus ==
                                    null
                                ? 'Not Submitted yet'
                                : DateFormat('dd, MMM yyyy, HH.mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        activeDepartmentModel.checkOutTime! *
                                            1000),
                                  ),
                            children: <Widget>[
                              activeDepartmentModel.checkOutStatus == null
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          BlocProvider.of<DepartmentCubit>(
                                              context,
                                              listen: false)
                                            ..checkOutActiveDepartment();
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
                                              activeDepartmentModel
                                                      .checkOutStatus ??
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
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      activeDepartmentModel
                                                              .checkOutTime! *
                                                          1000),
                                            ),
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        // ! Ubah ke VERIFIED setelah integrasi supervior Selesai
                        if (activeDepartmentModel.checkInStatus ==
                            'VERIFIED') ...[
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
                                          activeDepartmentModel:
                                              activeDepartmentModel,
                                        )
                                      : buildItemGrid(
                                          activeDepartmentModel:
                                              activeDepartmentModel,
                                        ));
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                }
                return CustomLoading();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Column buildItemGrid({required ActiveDepartmentModel activeDepartmentModel}) {
    bool isSglCstShow =
        !activeDepartmentModel.unitName!.toUpperCase().contains('FORENSIK') &&
            activeDepartmentModel.unitName?.toCapitalize() != 'IKM-IKK';
    return Column(
      key: const ValueKey(1),
      children: <Widget>[
        GridMenuRow(
          itemColor: primaryColor,
          menus: listStudentMenu(isSglCstShow).sublist(0, 4),
          onTaps: onTaps(activeDepartmentModel).sublist(0, 4),
        ),
        const SizedBox(height: 12),
        GridMenuRow(
          itemColor: variant2Color,
          menus: listStudentMenu(isSglCstShow).sublist(4, 8),
          onTaps: onTaps(activeDepartmentModel).sublist(4, 8),
        ),
        if (onTaps(activeDepartmentModel).length > 8) ...[
          const SizedBox(height: 12),
          GridMenuRow(
            length: 1,
            itemColor: variant1Color,
            menus: listStudentMenu(isSglCstShow).sublist(8, 9),
            onTaps: onTaps(activeDepartmentModel).sublist(8, 9),
          ),
        ],
      ],
    );
  }

  Column buildItemList({required ActiveDepartmentModel activeDepartmentModel}) {
    bool isSglCstShow =
        activeDepartmentModel.unitName!.toUpperCase().contains('FORENSIK') &&
            activeDepartmentModel.unitName?.toUpperCase() != 'IKM-IKK';
    return Column(
      key: const ValueKey(2),
      children: <Widget>[
        ListMenuColumn(
            itemColor: primaryColor,
            menus: listStudentMenu(isSglCstShow).sublist(0, 4),
            onTaps: onTaps(activeDepartmentModel).sublist(0, 4)),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
            itemColor: variant2Color,
            menus: listStudentMenu(isSglCstShow).sublist(4, 8),
            onTaps: onTaps(activeDepartmentModel).sublist(4, 8)),
        if (onTaps(activeDepartmentModel).length > 8) ...[
          const Divider(
            height: 30,
            thickness: 1,
            color: Color(0xFFEFF0F9),
          ),
          ListMenuColumn(
            length: 1,
            itemColor: variant1Color,
            menus: listStudentMenu(isSglCstShow).sublist(8, 9),
            onTaps: onTaps(activeDepartmentModel).sublist(8, 9),
          ),
        ],
      ],
    );
  }
}
