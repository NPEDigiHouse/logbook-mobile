import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/list_week_item.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/daily_activity/add_week_dialog.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyActivityAddWeekPage extends StatefulWidget {
  final DepartmentModel unit;
  const DailyActivityAddWeekPage({super.key, required this.unit});

  @override
  State<DailyActivityAddWeekPage> createState() =>
      _DailyActivityAddWeekPageState();
}

class _DailyActivityAddWeekPageState extends State<DailyActivityAddWeekPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
      ..getListWeek(unitId: widget.unit.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week of Deparment'),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
            ..getListWeek(unitId: widget.unit.id)),
        ]),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: DepartmentHeader(unitName: widget.unit.name),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              BlocBuilder<DailyActivityCubit, DailyActivityState>(
                builder: (context, state) {
                  if (state.weekItems != null)
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: AddWeeksCard(
                          unitId: widget.unit.id,
                          index: state.weekItems!.length,
                        ),
                      ),
                    );
                  return SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              BlocConsumer<DailyActivityCubit, DailyActivityState>(
                listener: (context, state) {
                  if (state.isRemoveWeekSuccess) {
                    BlocProvider.of<DailyActivityCubit>(context)
                        .getListWeek(unitId: widget.unit.id);
                  }
                },
                builder: (context, state) {
                  if (state.weekItems != null) {
                    if (state.weekItems!.isNotEmpty) {
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemCount: state.weekItems!.length,
                          itemBuilder: (context, index) {
                            final data = state.weekItems![index].days ?? [];

                            data.sort(
                              (a, b) {
                                // Urutkan berdasarkan urutan hari dalam seminggu
                                final daysOfWeek = [
                                  'MONDAY',
                                  'TUESDAY',
                                  'WEDNESDAY',
                                  'THURSDAY',
                                  'FRIDAY',
                                  'SATURDAY',
                                  'SUNDAY'
                                ];
                                return daysOfWeek
                                    .indexOf(a.day!)
                                    .compareTo(daysOfWeek.indexOf(b.day!));
                              },
                            );
                            return DailyActivtyWeekCard(
                              days: data,
                              departmentId: widget.unit.id,
                              weekItem: state.weekItems![index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 12,
                            );
                          },
                        ),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: EmptyData(
                            title: 'No Weeks Added',
                            subtitle: 'Please add week before'),
                      );
                    }
                  }

                  return SliverToBoxAdapter(child: CustomLoading());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DailyActivtyWeekCard extends StatefulWidget {
  const DailyActivtyWeekCard({
    super.key,
    required this.days,
    required this.weekItem,
    required this.departmentId,
  });

  final List<Day> days;
  final String departmentId;
  final ListWeekItem weekItem;

  @override
  State<DailyActivtyWeekCard> createState() => _DailyActivtyWeekCardState();
}

class _DailyActivtyWeekCardState extends State<DailyActivtyWeekCard> {
  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.fromMillisecondsSinceEpoch(
        widget.weekItem.startDate == null
            ? DateTime.now().millisecondsSinceEpoch
            : widget.weekItem.startDate! * 1000);
    final endDate = DateTime.fromMillisecondsSinceEpoch(
        widget.weekItem.endDate == null
            ? DateTime.now().millisecondsSinceEpoch
            : widget.weekItem.endDate! * 1000);
    bool expiredDate = endDate.isBefore(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ));
    bool expired = expiredDate && widget.weekItem.status == false;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      return Text(
                        Utils.epochToStringDate(
                            startTime: widget.weekItem.startDate ??
                                DateTime.now().millisecondsSinceEpoch ~/ 1000,
                            endTime: widget.weekItem.endDate ??
                                DateTime.now().millisecondsSinceEpoch ~/ 1000),
                        style: textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    Text(
                      'Status: ${expired ? "Expired" : "Active"}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                ),
                onSelected: (value) {
                  if (value == 'Edit') {
                    showDialog(
                      context: context,
                      barrierLabel: '',
                      barrierDismissible: false,
                      builder: (_) => AddWeekDialog(
                        isExpired: expired,
                        isExpiredDate: expiredDate,
                        status: widget.weekItem.status,
                        departmentId: widget.departmentId,
                        weekNum: widget.weekItem.weekName ?? 0,
                        startDate: startDate,
                        endDate: endDate,
                        isEdit: true,
                        id: widget.weekItem.id,
                      ),
                    );
                  }

                  if (value == 'Delete') {
                    showDialog(
                      context: context,
                      barrierLabel: '',
                      barrierDismissible: false,
                      builder: (_) => VerifyDialog(
                        onTap: () {
                          BlocProvider.of<DailyActivityCubit>(context)
                            ..deleteWeekByCoordinator(id: widget.weekItem.id!);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 6,
          ),
          ItemDivider(),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < widget.days.length; i++)
                Text(
                  widget.days[i].day!.substring(0, 3),
                  style: textTheme.bodySmall?.copyWith(
                    color: onFormDisableColor,
                  ),
                )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          ItemDivider(),
        ],
      ),
    );
  }
}

class AddWeeksCard extends StatelessWidget {
  final String unitId;
  final int index;

  const AddWeeksCard({super.key, required this.unitId, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: () {
        if (index != -1)
          showDialog(
            context: context,
            barrierLabel: '',
            barrierDismissible: false,
            builder: (_) => AddWeekDialog(
              departmentId: unitId,
              weekNum: index,
            ),
          );
      },
      color: primaryColor,
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 6,
            color: Color(0xFFD4D4D4).withOpacity(.25)),
        BoxShadow(
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
            color: Color(0xFFD4D4D4).withOpacity(.25)),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: Opacity(
                opacity: .3,
                child: SvgPicture.asset(
                  AssetPath.getVector('ellipse_1.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Opacity(
                opacity: .6,
                child: SvgPicture.asset(
                  AssetPath.getVector('half_ellipse.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Add Weeks',
                        style: textTheme.titleMedium?.copyWith(
                          color: scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Add new weeks to this unit',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.75),
                        ),
                      )
                    ],
                  )),
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
