import 'package:common/features/history/history_data.dart';
import 'package:common/features/notification/utils/notif_item_helper.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/history_cubit/history_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/main_app_bar.dart';

enum UserHistoryRole {
  student,
  supervisor,
  coordinator,
  supervisorCeu,
  supervisorKabag,
  supervisorCeuKabag
}

class HistoryView extends StatefulWidget {
  final UserHistoryRole role;
  final String? supervisorId;
  final List<String>? departmentName;
  const HistoryView({
    super.key,
    this.departmentName,
    this.supervisorId,
    required this.role,
  });

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  ValueNotifier<List<Activity>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final List<String> _menuList;

  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  @override
  void initState() {
    _menuList = [
      'All',
      'Clinical Record',
      'Scientific Session',
      'SGL',
      'CST',
      'Self Reflection',
      'Case',
      'Skill',
      'Mini Cex',
      'Personal Behavior',
      'Scientific Assesment',
      'Problem Consultation',
      'Daily Activity',
      if (widget.role == UserHistoryRole.supervisorKabag ||
          widget.role == UserHistoryRole.supervisorCeuKabag)
        'Check-in',
    ];

    Future.microtask(() {
      BlocProvider.of<HistoryCubit>(context).getHistories();
    });
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier(_menuList[0]);
    _dataFilters = ValueNotifier(null);

    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _selectedMenu.dispose();
    _dataFilters.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            MainTitleAppBar(
              isPin: false,
              title: 'Activity History',
              widget: [
                ValueListenableBuilder(
                  valueListenable: isSearchExpand,
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        if (value)
                          Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                              )),
                        IconButton(
                          onPressed: () {
                            isSearchExpand.value = !value;
                          },
                          icon: const Icon(CupertinoIcons.search),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () {
            isMounted = false;
            return Future.wait(
                [BlocProvider.of<HistoryCubit>(context).getHistories()]);
          },
          child: ValueListenableBuilder(
              valueListenable: listData,
              builder: (context, s, _) {
                return BlocConsumer<HistoryCubit, HistoryState>(
                  listener: (context, state) {
                    if (state.histories != null &&
                        state.requestState == RequestState.data) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listData.value = [
                            ...HistoryHelper.convertHistoryToActivity(
                              history: state.histories!,
                              isCeu: (widget.role ==
                                      UserHistoryRole.supervisorCeu ||
                                  widget.role ==
                                      UserHistoryRole.supervisorCeuKabag),
                              isHeadDiv: widget.role ==
                                      UserHistoryRole.supervisorKabag ||
                                  widget.role ==
                                      UserHistoryRole.supervisorCeuKabag,
                              unitIds: widget.departmentName,
                              isCoordinator:
                                  widget.role == UserHistoryRole.coordinator,
                              isStudent: widget.role == UserHistoryRole.student,
                              supervisorId: widget.supervisorId,
                              roleHistory:
                                  widget.role == UserHistoryRole.student
                                      ? RoleHistory.student
                                      : RoleHistory.supervisor,
                              context: context,
                            )
                          ];
                        });
                        isMounted = true;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state.histories == null ||
                        state.requestState == RequestState.loading) {
                      return const CustomLoading();
                    }
                    return ValueListenableBuilder(
                      valueListenable: isSearchExpand,
                      builder: (context, status, child) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Builder(
                                  builder: (context) {
                                    if (s.isEmpty) {
                                      return const EmptyData(
                                          title: 'No Activity Yet',
                                          subtitle:
                                              'there is no activity history yet');
                                    }

                                    return CustomScrollView(
                                      slivers: <Widget>[
                                        if (status)
                                          SliverToBoxAdapter(
                                            child: SizedBox(
                                              height: (widget.role ==
                                                      UserHistoryRole
                                                          .coordinator)
                                                  ? 80
                                                  : 140,
                                            ),
                                          ),
                                        SliverGroupedListView<Activity,
                                            DateTime>(
                                          elements: s,
                                          groupBy: (activity) {
                                            final now = DateTime.now();
                                            final now2 = DateTime(
                                                now.year, now.month, now.day);
                                            var difference =
                                                now2.difference(activity.date!);
                                            if (difference.inDays == 0) {
                                              return now2;
                                            } else if (difference.inDays <= 1) {
                                              return now2.subtract(
                                                  const Duration(days: 1));
                                            } else if (difference.inDays <= 7) {
                                              return now2.subtract(
                                                  const Duration(days: 6));
                                            } else if (difference.inDays <=
                                                30) {
                                              return now2.subtract(
                                                  const Duration(days: 30));
                                            } else {
                                              return DateTime(2020);
                                            }
                                          },
                                          groupComparator: (date1, date2) =>
                                              date2.compareTo(date1),
                                          itemBuilder: (context, activity) {
                                            return _NotifCard(
                                              activity: activity,
                                              role: widget.role,
                                            );
                                          },
                                          groupSeparatorBuilder: (date) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 16, 0, 8),
                                                  child: Text(
                                                    NotifiItemHelper.getTimeAgo(
                                                        date),
                                                    style: textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          separator: const Divider(
                                            height: 1,
                                            thickness: 1,
                                            indent: 20,
                                            endIndent: 20,
                                            color: Color(0xFFEFF0F9),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (status)
                              Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: scaffoldBackgroundColor,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              color: Colors.black12,
                                              blurRadius: 12,
                                              spreadRadius: 4)
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SearchField(
                                            onChanged: (value) {
                                              final data = state.histories!
                                                  .where((element) => (element
                                                              .studentName ??
                                                          '')
                                                      .toLowerCase()
                                                      .contains(
                                                          value.toLowerCase()))
                                                  .toList();
                                              if (value.isEmpty) {
                                                listData.value.clear();
                                                listData.value = [
                                                  ...HistoryHelper.convertHistoryToActivity(
                                                      history: state.histories!,
                                                      roleHistory: widget.role ==
                                                              UserHistoryRole
                                                                  .student
                                                          ? RoleHistory.student
                                                          : RoleHistory
                                                              .supervisor,
                                                      context: context,
                                                      isCoordinator: widget.role ==
                                                          UserHistoryRole
                                                              .coordinator,
                                                      isStudent: widget.role ==
                                                          UserHistoryRole
                                                              .student,
                                                      isCeu: (widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeu ||
                                                          widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeuKabag),
                                                      isHeadDiv: widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorKabag ||
                                                          widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeuKabag,
                                                      unitIds: widget.departmentName,
                                                      supervisorId: widget.supervisorId)
                                                ];
                                              } else {
                                                listData.value = [
                                                  ...HistoryHelper.convertHistoryToActivity(
                                                      history: data,
                                                      roleHistory: widget.role ==
                                                              UserHistoryRole
                                                                  .student
                                                          ? RoleHistory.student
                                                          : RoleHistory
                                                              .supervisor,
                                                      context: context,
                                                      isCoordinator: widget.role ==
                                                          UserHistoryRole
                                                              .coordinator,
                                                      isStudent: widget.role ==
                                                          UserHistoryRole
                                                              .student,
                                                      isCeu: (widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeu ||
                                                          widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeuKabag),
                                                      isHeadDiv: widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorKabag ||
                                                          widget.role ==
                                                              UserHistoryRole
                                                                  .supervisorCeuKabag,
                                                      unitIds: widget.departmentName,
                                                      supervisorId: widget.supervisorId)
                                                ];
                                              }
                                            },
                                            onClear: () {
                                              listData.value.clear();
                                              listData.value = [
                                                ...HistoryHelper.convertHistoryToActivity(
                                                    history: state.histories!,
                                                    roleHistory: widget.role ==
                                                            UserHistoryRole
                                                                .student
                                                        ? RoleHistory.student
                                                        : RoleHistory
                                                            .supervisor,
                                                    context: context,
                                                    isCoordinator:
                                                        widget.role ==
                                                            UserHistoryRole
                                                                .coordinator,
                                                    isStudent: widget.role ==
                                                        UserHistoryRole.student,
                                                    isCeu: (widget.role ==
                                                            UserHistoryRole
                                                                .supervisorCeu ||
                                                        widget.role ==
                                                            UserHistoryRole
                                                                .supervisorCeuKabag),
                                                    isHeadDiv: widget.role ==
                                                            UserHistoryRole
                                                                .supervisorKabag ||
                                                        widget.role ==
                                                            UserHistoryRole
                                                                .supervisorCeuKabag,
                                                    unitIds:
                                                        widget.departmentName,
                                                    supervisorId: widget.supervisorId)
                                              ];
                                            },
                                            text: '',
                                            hint: 'Search for student',
                                          ),
                                        ),
                                        if (widget.role ==
                                            UserHistoryRole.coordinator)
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        if (widget.role !=
                                            UserHistoryRole.coordinator)
                                          SizedBox(
                                            height: 64,
                                            child: ListView.separated(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _menuList.length,
                                              itemBuilder: (context, index) {
                                                return ValueListenableBuilder(
                                                  valueListenable:
                                                      _selectedMenu,
                                                  builder:
                                                      (context, value, child) {
                                                    final selected = value ==
                                                        _menuList[index];

                                                    return RawChip(
                                                      pressElevation: 0,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      label: Text(
                                                          _menuList[index]),
                                                      labelPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6,
                                                      ),
                                                      labelStyle: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        color: selected
                                                            ? primaryColor
                                                            : primaryTextColor,
                                                      ),
                                                      side: BorderSide(
                                                        color: selected
                                                            ? Colors.transparent
                                                            : borderColor,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      checkmarkColor:
                                                          primaryColor,
                                                      selectedColor:
                                                          primaryColor
                                                              .withOpacity(.2),
                                                      selected: selected,
                                                      onSelected: (_) {
                                                        _selectedMenu.value =
                                                            _menuList[index];
                                                        switch (index) {
                                                          case 1:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'CLINICAL RECORD')
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 2:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'SCIENTIFIC SESSION'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];

                                                            break;
                                                          case 3:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'SGL'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 4:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'CST'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 5:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Self-Reflection'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 6:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'CASE'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 7:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'SKILL'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 8:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'MINI_CEX'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 9:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'PERSONAL_BEHAVIOUR'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 10:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'SCIENTIFIC_ASSESMENT'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 11:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Problem Consultation'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 12:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'DAILY_ACTIVITY'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 13:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Check-in'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 14:
                                                            final data = state
                                                                .histories!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Check-out'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: data,
                                                                  isCeu: (widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId: widget
                                                                      .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                            break;
                                                          case 0:
                                                            listData.value
                                                                .clear();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  isCoordinator: widget.role ==
                                                                      UserHistoryRole
                                                                          .coordinator,
                                                                  isStudent: widget
                                                                          .role ==
                                                                      UserHistoryRole
                                                                          .student,
                                                                  history: state
                                                                      .histories!,
                                                                  isCeu: (widget.role == UserHistoryRole.supervisorCeu ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag),
                                                                  isHeadDiv: widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorKabag ||
                                                                      widget.role ==
                                                                          UserHistoryRole
                                                                              .supervisorCeuKabag,
                                                                  unitIds: widget
                                                                      .departmentName,
                                                                  supervisorId:
                                                                      widget
                                                                          .supervisorId,
                                                                  roleHistory: widget.role ==
                                                                          UserHistoryRole.student
                                                                      ? RoleHistory.student
                                                                      : RoleHistory.supervisor,
                                                                  context: context),
                                                            ];
                                                          default:
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(width: 8),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final Activity activity;
  final UserHistoryRole role;
  const _NotifCard({required this.activity, required this.role});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: activity.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 68,
                  height: 68,
                  color: primaryColor.withOpacity(.1),
                  child: Center(
                    child: SvgPicture.asset(
                      activity.iconPath,
                      color: primaryColor,
                      width: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      activity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: primaryColor,
                        height: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          Utils.datetimeToString(activity.date!,
                              format: 'EEE, dd MMM'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            height: 1.2,
                          ),
                        ),
                        // if (activity.verificationStatus == 'VERIFIED')
                        //   const Icon(
                        //     Icons.verified_rounded,
                        //     color: primaryColor,
                        //     size: 16,
                        //   )
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (role == UserHistoryRole.student) ...[
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: onFormDisableColor,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Supervisor:\t',
                            ),
                            TextSpan(
                              text: activity.supervisorId ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (role != UserHistoryRole.student) ...[
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: onFormDisableColor,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Student Name:\t',
                            ),
                            TextSpan(
                              text: Utils.capitalizeFirstLetter(
                                  activity.studentName),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: onFormDisableColor,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Student Id: ',
                            ),
                            TextSpan(
                              text: activity.studentId,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (activity.unitName != null) ...[
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: onFormDisableColor,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Department: ',
                            ),
                            TextSpan(
                              text: activity.unitName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
