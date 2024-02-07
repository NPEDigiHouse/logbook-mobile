import 'package:common/features/notification/utils/notif_item_helper.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/unit_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

class SelectDepartmentSheet extends StatefulWidget {
  final DepartmentModel? initUnit;
  final FilterType filterType;
  final dynamic Function(FilterType type, DepartmentModel? unit) onTap;
  const SelectDepartmentSheet({
    super.key,
    required this.onTap,
    required this.filterType,
    this.initUnit,
  });

  @override
  State<SelectDepartmentSheet> createState() => _SelectDepartmentSheetState();
}

class _SelectDepartmentSheetState extends State<SelectDepartmentSheet> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DepartmentCubit>(context, listen: false)
        .fetchDepartments(true);
  }

  final List<DepartmentModel> departments = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: BlocConsumer<DepartmentCubit, DepartmentState>(
        listener: (context, state) {
          if (state is FetchSuccess) {
            departments.clear();
            departments.addAll(state.units);
          }
        },
        builder: (context, state) {
          if (state is FetchSuccess) {
            return _BuildView(
              departments: departments,
              onTap: widget.onTap,
              filterType: widget.filterType,
              unit: widget.initUnit,
            );
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: const Column(
              children: [CircularProgressIndicator()],
            ),
          );
        },
      ),
    );
  }
}

class SelectFilterSheet extends StatefulWidget {
  final DepartmentModel? initUnit;
  final ActivityType? filterType;
  final bool? isUnreadOnly;
  final dynamic Function(
      ActivityType? type, DepartmentModel? unit, bool? isUnreadOnly) onTap;
  const SelectFilterSheet({
    super.key,
    required this.onTap,
    required this.filterType,
    this.initUnit,
    this.isUnreadOnly,
  });

  @override
  State<SelectFilterSheet> createState() => _SelectFilterSheetState();
}

class _SelectFilterSheetState extends State<SelectFilterSheet> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DepartmentCubit>(context, listen: false)
        .fetchDepartments(true);
  }

  final List<DepartmentModel> departments = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: BlocConsumer<DepartmentCubit, DepartmentState>(
        listener: (context, state) {
          if (state is FetchSuccess) {
            departments.clear();
            departments.addAll(state.units);
          }
        },
        builder: (context, state) {
          if (state is FetchSuccess) {
            return _BuildView2(
              departments: departments,
              onTap: widget.onTap,
              filterType: widget.filterType,
              unit: widget.initUnit,
              isUnreadOnly: widget.isUnreadOnly,
            );
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: const Column(
              children: [CircularProgressIndicator()],
            ),
          );
        },
      ),
    );
  }
}

class _BuildView extends StatefulWidget {
  const _BuildView({
    required this.departments,
    required this.onTap,
    required this.filterType,
    required this.unit,
  });
  final List<DepartmentModel> departments;
  final dynamic Function(FilterType type, DepartmentModel? unit) onTap;
  final FilterType filterType;
  final DepartmentModel? unit;

  @override
  State<_BuildView> createState() => _BuildViewState();
}

class _BuildViewState extends State<_BuildView> {
  final List<FilterType> types = [
    FilterType.all,
    FilterType.unverified,
    FilterType.verified
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.unit != null && widget.departments.isNotEmpty) {
        context.read<FilterNotifier>().setDepartmentModel =
            widget.departments.firstWhere((it) {
          return it.id == widget.unit?.id;
        });
      }
      context.read<FilterNotifier>().setFilterType = widget.filterType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterNotifier>(builder: (context, ctf, _) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFFD1D5DB),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filter Data',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ItemDivider(),
            DropdownButtonFormField(
              isExpanded: true,
              hint: const Text('All'),
              items: types
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(Utils.capitalizeFirstLetter(e.name)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<FilterNotifier>().setFilterType = value;
                }
              },
              value: ctf.filterType,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              isExpanded: true,
              hint: const Text('Select Department'),
              items: widget.departments
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(Utils.capitalizeFirstLetter(e.name)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<FilterNotifier>().setDepartmentModel = value;
                }
              },
              value: ctf.unit,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 2, color: primaryColor),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        widget.onTap(FilterType.unverified, null);
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        widget.onTap(ctf.filterType, ctf.unit);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class _BuildView2 extends StatefulWidget {
  const _BuildView2({
    required this.departments,
    required this.onTap,
    required this.filterType,
    required this.unit,
    this.isUnreadOnly,
  });
  final List<DepartmentModel> departments;
  final dynamic Function(
      ActivityType? type, DepartmentModel? unit, bool? isUnreadOnly) onTap;
  final ActivityType? filterType;
  final DepartmentModel? unit;
  final bool? isUnreadOnly;

  @override
  State<_BuildView2> createState() => _BuildView2State();
}

class _BuildView2State extends State<_BuildView2> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.unit != null && widget.departments.isNotEmpty) {
        context.read<FilterNotifier>().setDepartmentModel =
            widget.departments.firstWhere((it) {
          return it.id == widget.unit?.id;
        });
      }
      context.read<FilterNotifier>().setActivityType = widget.filterType;
      context.read<FilterNotifier>().setUnreadOnlyStatus =
          widget.isUnreadOnly ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterNotifier>(builder: (context, ctf, _) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFFD1D5DB),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                const Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filter Data',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ItemDivider(),
            DropdownButtonFormField(
              isExpanded: true,
              hint: const Text('Select Type'),
              items: NotifiItemHelper.getActivityType.entries
                  .map((e) => DropdownMenuItem(
                        value: e.value,
                        child: Text(e.key.replaceAll("_", " ").toUpperCase()),
                      ))
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  context.read<FilterNotifier>().setActivityType = value;
                }
              },
              value: ctf.activityType,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              isExpanded: true,
              hint: const Text('Select Department'),
              items: widget.departments
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(Utils.capitalizeFirstLetter(e.name)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<FilterNotifier>().setDepartmentModel = value;
                }
              },
              value: ctf.unit,
            ),
            CheckboxListTile(
              value: ctf.isUnreadOnly,
              title: const Text('Show Unread Only'),
              onChanged: (value) {
                context.read<FilterNotifier>().setUnreadOnlyStatus =
                    value ?? false;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 2, color: primaryColor),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        widget.onTap(null, null, false);
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        widget.onTap(
                            ctf.activityType, ctf.unit, ctf.isUnreadOnly);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
