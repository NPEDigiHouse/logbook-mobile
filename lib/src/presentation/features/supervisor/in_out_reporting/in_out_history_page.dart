import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/history_cubit/history_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_data.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';

class InOutHistoryPage extends StatefulWidget {
  const InOutHistoryPage({
    super.key,
  });

  @override
  State<InOutHistoryPage> createState() => _InOutHistoryPageState();
}

class _InOutHistoryPageState extends State<InOutHistoryPage> {
  ValueNotifier<List<Activity>> listData = ValueNotifier([]);
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
      BlocProvider.of<HistoryCubit>(context)..getHistories();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('In Out History'),
      ),
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                toolbarHeight: kToolbarHeight + 85,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                ),
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildSearchFilterSection(),
                  ],
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () => Future.wait([
              BlocProvider.of<HistoryCubit>(context).getHistories(),
            ]),
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
                                state.histories!,
                                onlyInOut: true,
                                RoleHistory.supervisor,
                                context,
                              )
                            ];
                          });
                          isMounted = true;
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.histories != null &&
                          state.requestState == RequestState.data) {
                        if (s.isNotEmpty) {
                          return CustomScrollView(
                            slivers: <Widget>[
                              SliverGroupedListView<Activity, DateTime>(
                                elements: s,
                                groupBy: (activity) => activity.date!,
                                groupComparator: (date1, date2) =>
                                    date1.compareTo(date2) * -1,
                                itemBuilder: (context, activity) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: activity.onTap,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: 68,
                                                height: 68,
                                                color: primaryColor
                                                    .withOpacity(.1),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        activity.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Icon(
                                                        Icons.verified_rounded,
                                                        size: 16,
                                                        color: primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style: textTheme.bodySmall
                                                          ?.copyWith(
                                                        color:
                                                            secondaryTextColor,
                                                      ),
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                          text:
                                                              'Student Name:\t',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                            text: activity
                                                                .studentName),
                                                      ],
                                                    ),
                                                  ),
                                                  ...[
                                                    const SizedBox(height: 4),
                                                    RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                'Student Id: ',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: activity
                                                                .studentId,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  if (activity.patientName !=
                                                      null) ...[
                                                    const SizedBox(height: 4),
                                                    RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: 'Patient: ',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: activity
                                                                .patientName,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                },
                                groupSeparatorBuilder: (date) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Divider(
                                        height: 6,
                                        thickness: 6,
                                        color: onDisableColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 16, 20, 8),
                                        child: Text(
                                          timeago.format(date),
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
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
                        } else {
                          return EmptyData(
                              title: 'No Activity Yet',
                              subtitle: 'there is no activity history yet');
                        }
                      }
                      return CustomLoading();
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Stack buildTitleSection() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 16,
          top: 0,
          child: SvgPicture.asset(
            AssetPath.getVector('circle_bg2.svg'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'History',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ValueListenableBuilder<Map<String, String>?> buildSearchFilterSection() {
    return ValueListenableBuilder(
      valueListenable: _dataFilters,
      builder: (context, data, value) {
        return BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                if (data != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: textTheme.labelSmall,
                            children: <TextSpan>[
                              const TextSpan(text: 'From\t'),
                              TextSpan(
                                text: data['start_date'],
                                style: textTheme.bodyLarge?.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                              const TextSpan(text: '\tto\t'),
                              TextSpan(
                                text: data['end_date'],
                                style: textTheme.bodyLarge?.copyWith(
                                  color: primaryColor,
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
                            style: textTheme.labelSmall,
                            children: <TextSpan>[
                              const TextSpan(text: 'Activity\t'),
                              TextSpan(
                                text: data['activity']!.toCapitalize(),
                                style: textTheme.bodyLarge?.copyWith(
                                  color: primaryColor,
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
                            style: textTheme.labelSmall,
                            children: <TextSpan>[
                              const TextSpan(text: 'Status\t'),
                              TextSpan(
                                text: data['status']!.toCapitalize(),
                                style: textTheme.bodyLarge?.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _dataFilters.value = null,
                            child: const Text(
                              'Reset filter',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: SearchField(
                      text: '',
                      hint: 'Search Student',
                      onChanged: (value) {
                        final data = state.histories!
                            .where((element) => element.studentName!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                        if (value.isEmpty) {
                          listData.value.clear();
                          listData.value = [
                            ...HistoryHelper.convertHistoryToActivity(
                                state.histories!,
                                RoleHistory.supervisor,
                                context,
                                onlyInOut: true)
                          ];
                        } else {
                          listData.value = [
                            ...HistoryHelper.convertHistoryToActivity(
                                data, RoleHistory.supervisor, context,
                                onlyInOut: true)
                          ];
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _menuList.length,
                      itemBuilder: (context, index) {
                        return ValueListenableBuilder(
                          valueListenable: _selectedMenu,
                          builder: (context, value, child) {
                            final selected = value == _menuList[index];

                            return RawChip(
                              pressElevation: 0,
                              clipBehavior: Clip.antiAlias,
                              label: Text(_menuList[index]),
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              labelStyle: textTheme.bodyMedium?.copyWith(
                                color:
                                    selected ? primaryColor : primaryTextColor,
                              ),
                              side: BorderSide(
                                color:
                                    selected ? Colors.transparent : borderColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              checkmarkColor: primaryColor,
                              selectedColor: primaryColor.withOpacity(.2),
                              selected: selected,
                              onSelected: (_) {
                                _selectedMenu.value = _menuList[index];
                                switch (index) {
                                  case 1:
                                    final data = state.histories!
                                        .where((element) =>
                                            element.type!.toUpperCase() ==
                                            'Check-in'.toUpperCase())
                                        .toList();
                                    listData.value = [
                                      ...HistoryHelper.convertHistoryToActivity(
                                          data,
                                          onlyInOut: true,
                                          RoleHistory.supervisor,
                                          context),
                                    ];
                                    break;
                                  case 2:
                                    final data = state.histories!
                                        .where((element) =>
                                            element.type!.toUpperCase() ==
                                            'Check-out'.toUpperCase())
                                        .toList();
                                    listData.value = [
                                      ...HistoryHelper.convertHistoryToActivity(
                                          data,
                                          onlyInOut: true,
                                          RoleHistory.supervisor,
                                          context),
                                    ];
                                    break;
                                  case 0:
                                    listData.value.clear();
                                    listData.value = [
                                      ...HistoryHelper.convertHistoryToActivity(
                                          state.histories!,
                                          onlyInOut: true,
                                          RoleHistory.supervisor,
                                          context),
                                    ];
                                  default:
                                }
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
