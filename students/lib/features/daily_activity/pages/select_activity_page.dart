import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:students/features/daily_activity/widgets/location_sheet.dart';

class SelectActivityPage extends StatefulWidget {
  final dynamic Function(ActivityModel activity) onTap;
  final ActivityModel? selectModelName;

  const SelectActivityPage(
      {super.key, required this.onTap, this.selectModelName});

  @override
  State<SelectActivityPage> createState() => _SelectActivityPageState();
}

class _SelectActivityPageState extends State<SelectActivityPage> {
  late ValueNotifier<ActivityModel?> selectedLocation;
  @override
  void initState() {
    super.initState();
    selectedLocation = ValueNotifier(widget.selectModelName);
    Future.microtask(() {
      BlocProvider.of<ActivityCubit>(context).getActivityLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedLocation,
        builder: (context, val, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select Activity Location'),
            ),
            body: SafeArea(
                child: BlocSelector<ActivityCubit, ActivityState,
                    List<ActivityModel>?>(
              selector: (state) => state.activityLocations,
              builder: (context, state) {
                if (state == null) return const CustomLoading();

                if (state.isEmpty) {
                  return const EmptyData(
                      title: 'Empty Activity Location',
                      subtitle: 'there is no activity location data yet');
                }

                final activeLocation =
                    state.indexWhere((element) => element.id == val?.id) != -1
                        ? [val]
                        : [];
                final notActive =
                    state.where((element) => element.id != val?.id).toList();
                final merge = <ActivityModel>[...activeLocation, ...notActive];

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: merge.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                  itemBuilder: (context, index) {
                    return InkWellContainer(
                      radius: 12,
                      onTap: () {
                        if (val?.id == merge[index].id) {
                          return;
                        }
                        if (merge[index].latitude == 0 ||
                            merge[index].longitude == 0) {
                          selectedLocation.value = merge[index];
                          widget.onTap.call(merge[index]);
                        } else {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            builder: (ctx) => LocationSheet(
                              onTap: (ActivityModel activity) {
                                selectedLocation.value = activity;
                                widget.onTap.call(activity);
                              },
                              model: merge[index],
                              isActive: merge[index] == val,
                            ),
                          );
                        }
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      color: val == merge[index]
                          ? primaryColor
                          : scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 16,
                          spreadRadius: 0,
                          color: const Color(0xFF374151).withOpacity(
                            .15,
                          ),
                        )
                      ],
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.map,
                            size: 16,
                            color: val == merge[index]
                                ? scaffoldBackgroundColor
                                : primaryTextColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Text(
                            merge[index].name ?? '',
                            style: textTheme.bodyMedium?.copyWith(
                                color: val == merge[index]
                                    ? scaffoldBackgroundColor
                                    : primaryTextColor),
                          )),
                          if (val == merge[index])
                            const Icon(
                              Icons.check_circle_rounded,
                              color: scaffoldBackgroundColor,
                            )
                        ],
                      ),
                    );
                  },
                );
              },
            )),
          );
        });
  }
}
