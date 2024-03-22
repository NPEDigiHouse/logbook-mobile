import 'package:common/features/notification/notification_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/datasources/local_datasources/static_datasource.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/glassmorphism.dart';
import 'package:main/widgets/grid_menu_row.dart';
import 'package:main/widgets/list_menu_column.dart';
import 'package:main/widgets/main_app_bar.dart';
import 'package:main/widgets/menu_switch.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:students/features/menu/home/student_home_page.skeleton.dart';
import 'package:students/features/recap/recap_page.dart';
import '../../assesment/assesment_home_page.dart';
import '../../clinical_record/pages/list_clinical_record_page.dart';
import '../../competences/competences_home_page.dart';
import '../../daily_activity/daily_activity_home_page.dart';
import '../widgets/report_expansion_tile.dart';
import '../../references/references_page.dart';
import '../../scientific_session/list_scientific_session_page.dart';
import '../../select_units/select_unit_page.dart';
import '../../self_reflection/self_reflection_home_page.dart';
import '../../sgl_cst/sgl_cst_home_page.dart';
import '../../special_reports/special_report_home_page.dart';

enum DepartmentStatus { process, complete, warning }

class StudentHomePage extends StatefulWidget {
  final UserCredential credential;
  const StudentHomePage({super.key, required this.credential});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<DepartmentCubit>(context, listen: false)
          .getActiveDepartment();
      BlocProvider.of<NotificationCubit>(context).getNotifications(page: 1);
      Future.microtask(() => BlocProvider.of<StudentCubit>(context)
          .getStudentRecap(
              studentId: widget.credential.student?.studentId ?? ''));
    });
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
        Future.microtask(() {
          BlocProvider.of<DepartmentCubit>(context, listen: false)
              .getActiveDepartment();
          BlocProvider.of<NotificationCubit>(context).getNotifications(page: 1);
        })
      ]),
      child: CustomScrollView(
        slivers: <Widget>[
          MainAppBar(
              notifIcon:
                  BlocSelector<NotificationCubit, NotificationState, int>(
                selector: (state) => state.unreadNotification,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Badge(
                      alignment: Alignment.topRight,
                      offset: const Offset(-6, 6),
                      label: Text(state.toString()),
                      isLabelVisible: state > 0,
                      child: IconButton(
                        onPressed: () => context.navigateTo(
                          const NotificationPage(role: UserRole.student),
                        ),
                        icon: const Icon(
                          CupertinoIcons.bell,
                          color: primaryTextColor,
                          size: 24,
                        ),
                        tooltip: 'Notification',
                      ),
                    ),
                  );
                },
              ),
              onTap: () {
                BlocProvider.of<DepartmentCubit>(context, listen: false)
                    .getActiveDepartment();
              }),
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
                if (state is CheckOutFailed) {
                  CustomAlert.error(message: state.message, context: context);
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
                                    color: primaryTextColor.withOpacity(.1),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: SvgPicture.asset(
                                  AssetPath.getVector('half_ellipse.svg'),
                                  color: primaryTextColor.withOpacity(.1),
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
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.navigateTo(
                                                SelectDepartmentPage(
                                              activeDepartmentModel:
                                                  unitCubit.activeDepartment,
                                            ));
                                          },
                                          child: Glassmorphism(
                                            blur: 5,
                                            opacity: .15,
                                            radius: 99,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons
                                                        .change_circle_outlined,
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
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        BlocSelector<StudentCubit, StudentState,
                                            bool>(
                                          selector: (state) =>
                                              state.studentDepartmentRecap
                                                  ?.isCompleted ??
                                              false,
                                          builder: (context, state) {
                                            return InkWell(
                                              onTap: () {
                                                context.navigateTo(
                                                    StudentRecapPage(
                                                  studentId: widget.credential
                                                          .student?.studentId ??
                                                      '',
                                                ));
                                              },
                                              child: Badge(
                                                alignment: Alignment.topRight,
                                                label: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: errorColor,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: const Text(
                                                      '!',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              scaffoldBackgroundColor),
                                                    )),
                                                padding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                isLabelVisible: !state,
                                                child: Glassmorphism(
                                                  blur: 5,
                                                  opacity: .15,
                                                  radius: 99,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          state
                                                              ? Icons
                                                                  .check_circle
                                                              : CupertinoIcons
                                                                  .hourglass,
                                                          size: 20,
                                                          color:
                                                              backgroundColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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
                                          showDialog(
                                              context: context,
                                              barrierLabel: '',
                                              barrierDismissible: false,
                                              builder: (_) => VerifyDialog(
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  DepartmentCubit>(
                                                              context,
                                                              listen: false)
                                                          .checkInActiveDepartment();
                                                      context.back();
                                                    },
                                                  ));
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
                                  ? BlocSelector<StudentCubit, StudentState,
                                      bool>(
                                      selector: (state) => true,
                                      builder: (context, state) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: FilledButton.icon(
                                            onPressed: (state)
                                                ? () {
                                                    showDialog(
                                                        context: context,
                                                        barrierLabel: '',
                                                        barrierDismissible:
                                                            false,
                                                        builder:
                                                            (_) => VerifyDialog(
                                                                  onTap: () {
                                                                    BlocProvider.of<DepartmentCubit>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .checkOutActiveDepartment();
                                                                    context
                                                                        .back();
                                                                  },
                                                                ));
                                                  }
                                                : null,
                                            icon: SvgPicture.asset(
                                              AssetPath.getIcon(
                                                  'send_alt_filled.svg'),
                                              width: 20,
                                            ),
                                            label: const Text('Send Report'),
                                          ),
                                        );
                                      },
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
                return const StudentHomePageSkeleton();
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
