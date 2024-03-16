import 'package:common/features/history/history_data.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/history_cubit/history_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/search_field.dart';

class InOutHistoryPage extends StatefulWidget {
  const InOutHistoryPage({
    super.key,
  });

  @override
  State<InOutHistoryPage> createState() => _InOutHistoryPageState();
}

class _InOutHistoryPageState extends State<InOutHistoryPage> {
  ValueNotifier<List<Activity>> listData = ValueNotifier([]);
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  bool isMounted = false;
  late final List<String> _menuList;

  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _menuList = [
      'All',
      'Check-in',
      'Check-Out',
    ];

    Future.microtask(() {
      BlocProvider.of<HistoryCubit>(context).getInOutHistories();
    });
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Out History'),
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
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.wait([
            BlocProvider.of<HistoryCubit>(context).getInOutHistories(),
          ]),
          child: ValueListenableBuilder(
              valueListenable: listData,
              builder: (context, s, _) {
                return BlocConsumer<HistoryCubit, HistoryState>(
                  listener: (context, state) {
                    if (state.historiesIo != null &&
                        state.requestStateIo == RequestState.data) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listData.value = [
                            ...HistoryHelper.convertHistoryToActivity(
                              history: state.historiesIo!,
                              onlyInOut: true,
                              roleHistory: RoleHistory.supervisor,
                              context: context,
                            )
                          ];
                        });
                        isMounted = true;
                      }
                    }
                  },
                  builder: (context, state) {
                    return ValueListenableBuilder(
                        valueListenable: isSearchExpand,
                        builder: (context, status, child) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: Builder(builder: (context) {
                                  if (state.requestStateIo ==
                                      RequestState.loading) {
                                    return const CustomLoading();
                                  } else if (state.historiesIo != null) {
                                    if (s.isEmpty) {
                                      return const EmptyData(
                                          title: 'No Activity Yet',
                                          subtitle:
                                              'there is no activity history yet');
                                    }
                                    return CustomScrollView(
                                      slivers: <Widget>[
                                        if (status)
                                          const SliverToBoxAdapter(
                                            child: SizedBox(height: 130),
                                          ),
                                        SliverPadding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          sliver: SliverList.separated(
                                            itemCount: s.length,
                                            itemBuilder: (context, index) {
                                              final data = s[index];
                                              return InkWellContainer(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                color: scaffoldBackgroundColor,
                                                radius: 12,
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 10,
                                                    color: Colors.black
                                                        .withOpacity(.08),
                                                  ),
                                                ],
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 56,
                                                      height: 56,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: data.title ==
                                                                "CHECK-IN"
                                                            ? primaryColor
                                                                .withOpacity(.4)
                                                            : variant2Color
                                                                .withOpacity(
                                                                    .4),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: data.title ==
                                                                    "CHECK-IN"
                                                                ? primaryColor
                                                                    .withOpacity(
                                                                        .6)
                                                                : variant2Color
                                                                    .withOpacity(
                                                                        .6),
                                                            strokeAlign: BorderSide
                                                                .strokeAlignOutside),
                                                      ),
                                                      child: Center(
                                                        child: data.title ==
                                                                "CHECK-IN"
                                                            ? const Icon(
                                                                Icons
                                                                    .arrow_downward_rounded,
                                                                size: 32,
                                                                color:
                                                                    primaryColor,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .arrow_upward_rounded,
                                                                size: 32,
                                                                color:
                                                                    variant2Color,
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.dateTime ?? '',
                                                          style: textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                            color:
                                                                secondaryTextColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          (data.title)
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: data.title ==
                                                                    "CHECK-IN"
                                                                ? primaryColor
                                                                : variant2Color,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          Utils.capitalizeFirstLetter(
                                                              data.studentName ??
                                                                  ""),
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  color:
                                                                      primaryTextColor,
                                                                  height: 1,
                                                                  fontSize: 13),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          data.studentId,
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  height: 1.2,
                                                                  color:
                                                                      secondaryTextColor,
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(
                                                height: 12,
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  return const CustomLoading();
                                }),
                              ),
                              if (status && state.historiesIo != null)
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: SearchField(
                                                  text: '',
                                                  hint: 'Search Student',
                                                  onClear: () {
                                                    listData.value.clear();
                                                    listData.value = [
                                                      ...HistoryHelper
                                                          .convertHistoryToActivity(
                                                              history: state
                                                                  .historiesIo!,
                                                              roleHistory:
                                                                  RoleHistory
                                                                      .supervisor,
                                                              context: context,
                                                              isCeu: false,
                                                              isHeadDiv: true)
                                                    ];
                                                  },
                                                  onChanged: (value) {
                                                    final data = state
                                                        .historiesIo!
                                                        .where((element) =>
                                                            (element.studentName ??
                                                                    '')
                                                                .toLowerCase()
                                                                .contains(value
                                                                    .toLowerCase()))
                                                        .toList();
                                                    if (value.isEmpty) {
                                                      listData.value.clear();
                                                      listData.value = [
                                                        ...HistoryHelper
                                                            .convertHistoryToActivity(
                                                          history: state
                                                              .historiesIo!,
                                                          roleHistory:
                                                              RoleHistory
                                                                  .supervisor,
                                                          context: context,
                                                          isCeu: false,
                                                          isHeadDiv: true,
                                                        )
                                                      ];
                                                    } else {
                                                      listData.value = [
                                                        ...HistoryHelper
                                                            .convertHistoryToActivity(
                                                          history: data,
                                                          roleHistory:
                                                              RoleHistory
                                                                  .supervisor,
                                                          context: context,
                                                          isCeu: false,
                                                          isHeadDiv: true,
                                                        )
                                                      ];
                                                    }
                                                  })),
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
                                                                .historiesIo!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Check-in'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  history: data,
                                                                  onlyInOut:
                                                                      true,
                                                                  roleHistory:
                                                                      RoleHistory
                                                                          .supervisor,
                                                                  context:
                                                                      context),
                                                            ];
                                                            break;
                                                          case 2:
                                                            final data = state
                                                                .historiesIo!
                                                                .where((element) =>
                                                                    element
                                                                        .type!
                                                                        .toUpperCase() ==
                                                                    'Check-out'
                                                                        .toUpperCase())
                                                                .toList();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  history: data,
                                                                  onlyInOut:
                                                                      true,
                                                                  roleHistory:
                                                                      RoleHistory
                                                                          .supervisor,
                                                                  context:
                                                                      context),
                                                            ];
                                                            break;
                                                          case 0:
                                                            listData.value
                                                                .clear();
                                                            listData.value = [
                                                              ...HistoryHelper.convertHistoryToActivity(
                                                                  history: state
                                                                      .historiesIo!,
                                                                  onlyInOut:
                                                                      true,
                                                                  roleHistory:
                                                                      RoleHistory
                                                                          .supervisor,
                                                                  context:
                                                                      context),
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
                        });
                  },
                );
              }),
        ),
      ),
    );
  }
}
