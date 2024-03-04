import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/utils/filter_type.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

import 'widgets/daily_activity_card.dart';
import '../sgl_cst/widgets/select_department_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorStudentsDailyActivityPage extends StatefulWidget {
  const SupervisorStudentsDailyActivityPage({super.key});

  @override
  State<SupervisorStudentsDailyActivityPage> createState() =>
      _SupervisorStudentsDailyActivityPageState();
}

class _SupervisorStudentsDailyActivityPageState
    extends State<SupervisorStudentsDailyActivityPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: _SupervisorListDailyActivityView(),
    );
  }
}

class _SupervisorListDailyActivityView extends StatefulWidget {
  @override
  State<_SupervisorListDailyActivityView> createState() =>
      _SupervisorListDailyActivityViewState();
}

class _SupervisorListDailyActivityViewState
    extends State<_SupervisorListDailyActivityView> {
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    page = 1;
    Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
        .getDailyActivityStudentBySupervisor(page: page, onScroll: false));
  }

  void _onScroll() {
    final state = context.read<DailyActivityCubit>().state.requestState;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final d = context.read<FilterNotifier>();
    BlocProvider.of<DailyActivityCubit>(context)
        .getDailyActivityStudentBySupervisor(
      unitId: d.unit?.id,
      query: query,
      page: page + 1,
      onScroll: true,
      type: d.filterType,
    );
    page++;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterNotifier>(builder: (context, ntf, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daily Activities'),
          actions: [
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
            Stack(
              children: [
                if (ntf.isFilter)
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
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      builder: (ctx) => SelectDepartmentSheet(
                        filterType: ntf.filterType,
                        initUnit: ntf.unit,
                        onTap: (f, u) {
                          page = 1;
                          context.read<FilterNotifier>().setFilterType = f;
                          context.read<FilterNotifier>().setDepartmentModel = u;
                          BlocProvider.of<DailyActivityCubit>(context)
                              .getDailyActivityStudentBySupervisor(
                            unitId: ntf.unit?.id,
                            query: query,
                            page: page,
                            type: f,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.line_horizontal_3_decrease,
                  ),
                ),
              ],
            )
          ],
        ).variant(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              page = 1;
              final d = context.read<FilterNotifier>();

              await Future.wait([
                BlocProvider.of<DailyActivityCubit>(context)
                    .getDailyActivityStudentBySupervisor(
                  unitId: ntf.unit?.id,
                  page: page,
                  query: query,
                  type: d.filterType,
                ),
              ]);
            },
            child: BlocConsumer<DailyActivityCubit, DailyActivityState>(
              listener: (context, state) {
                if (state.stateVerifyDailyActivity == RequestState.data) {
                  Future.microtask(
                    () => BlocProvider.of<DailyActivityCubit>(context)
                        .getDailyActivityStudentBySupervisor(
                            page: 1,
                            onScroll: false,
                            type: ntf.filterType,
                            unitId: ntf.unit?.id),
                  );
                }
              },
              builder: (context, state) {
                final data = state.dailyActivityStudents;

                return ValueListenableBuilder(
                    valueListenable: isSearchExpand,
                    builder: (context, status, _) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Builder(
                                builder: (context) {
                                  if (state.fetchState ==
                                      RequestState.loading) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: ntf.isFilter ? 200 : 150,
                                          ),
                                          const Center(child: CustomLoading()),
                                        ],
                                      ),
                                    );
                                  }
                                  if (data != null) {
                                    if (data.isEmpty) {
                                      return const EmptyData(
                                          title: 'Empty Daily Activity',
                                          subtitle:
                                              'there is no daily activity yet');
                                    }
                                    return CustomScrollView(
                                      controller: _scrollController,
                                      slivers: [
                                        if (status)
                                          SliverToBoxAdapter(
                                            child: SizedBox(
                                              height: ntf.isFilter ? 128 : 84,
                                            ),
                                          ),
                                        const SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: 8,
                                          ),
                                        ),
                                        SliverList.separated(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return DailyActivityCard(
                                              dailyActivityStudent: data[index],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 12,
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  }
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: ntf.isFilter ? 200 : 150,
                                        ),
                                        const Center(child: CustomLoading()),
                                      ],
                                    ),
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
                                          onClear: () {
                                            query = null;
                                            context
                                                .read<DailyActivityCubit>()
                                                .getDailyActivityStudentBySupervisor(
                                                  unitId: ntf.unit?.id,
                                                  page: page,
                                                  query: query,
                                                  type: ntf.filterType,
                                                );
                                          },
                                          onChanged: (value) {
                                            query = value;
                                            context
                                                .read<DailyActivityCubit>()
                                                .getDailyActivityStudentBySupervisor(
                                                    unitId: ntf.unit?.id,
                                                    page: page,
                                                    query: query,
                                                    type: ntf.filterType);
                                          },
                                          text: 'Search',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: SizedBox(
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 12),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                if (ntf.filterType !=
                                                    FilterType.all)
                                                  Chip(
                                                    backgroundColor:
                                                        primaryColor
                                                            .withOpacity(.1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: BorderSide.none,
                                                    ),
                                                    side: BorderSide(
                                                        color: secondaryColor
                                                            .withOpacity(.5)),
                                                    label: Text(ntf
                                                        .filterType.name
                                                        .toCapitalize()),
                                                    labelStyle: textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color:
                                                                primaryColor),
                                                    deleteIcon: const Icon(
                                                      Icons.close_rounded,
                                                      color: primaryColor,
                                                      size: 16,
                                                    ),
                                                    onDeleted: () {
                                                      context
                                                              .read<
                                                                  FilterNotifier>()
                                                              .setFilterType =
                                                          FilterType.all;
                                                      BlocProvider.of<
                                                                  DailyActivityCubit>(
                                                              context)
                                                          .getDailyActivityStudentBySupervisor(
                                                              unitId:
                                                                  ntf.unit?.id,
                                                              page: page,
                                                              query: query,
                                                              type: ntf
                                                                  .filterType);
                                                    },
                                                  ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                if (ntf.unit != null)
                                                  Chip(
                                                    backgroundColor:
                                                        primaryColor
                                                            .withOpacity(.1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: BorderSide.none,
                                                    ),
                                                    side: BorderSide(
                                                        color: secondaryColor
                                                            .withOpacity(.5)),
                                                    label: Text(
                                                        '${ntf.unit?.name.toCapitalize()}'),
                                                    labelStyle: textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color:
                                                                primaryColor),
                                                    deleteIcon: const Icon(
                                                      Icons.close_rounded,
                                                      color: primaryColor,
                                                      size: 16,
                                                    ),
                                                    onDeleted: () {
                                                      context
                                                          .read<
                                                              FilterNotifier>()
                                                          .setDepartmentModel = null;
                                                      BlocProvider.of<
                                                                  DailyActivityCubit>(
                                                              context)
                                                          .getDailyActivityStudentBySupervisor(
                                                              unitId:
                                                                  ntf.unit?.id,
                                                              page: page,
                                                              query: query,
                                                              type: ntf
                                                                  .filterType);
                                                    },
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
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    });
  }
}
