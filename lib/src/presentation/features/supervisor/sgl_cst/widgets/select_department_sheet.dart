import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDepartmentSheet extends StatefulWidget {
  final String? initUnit;
  final dynamic Function(String? filterUnitId) onTap;
  const SelectDepartmentSheet({
    super.key,
    required this.onTap,
    this.initUnit,
  });

  @override
  State<SelectDepartmentSheet> createState() => _SelectDepartmentSheetState();
}

class _SelectDepartmentSheetState extends State<SelectDepartmentSheet> {
  String? unitId;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DepartmentCubit>(context, listen: false)
      ..fetchDepartments(true);
  }

  final List<DepartmentModel> departments = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is FetchSuccess) {
          departments.clear();
          departments.addAll(state.units);
        }
      },
      builder: (context, state) {
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
                  Icon(
                    CupertinoIcons.line_horizontal_3_decrease,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filter Department',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ItemDivider(),
              DropdownButtonFormField(
                isExpanded: true,
                items: departments
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) unitId = value.id;
                },
                value: widget.initUnit == null
                    ? null
                    : departments.indexWhere(
                                (element) => element.id == widget.initUnit) ==
                            -1
                        ? null
                        : departments.firstWhere(
                            (element) => element.id == widget.initUnit),
              ),
              SizedBox(
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
                              side: BorderSide(width: 2, color: primaryColor),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {
                          widget.onTap(null);
                        },
                        child: Text('Reset'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          widget.onTap(unitId);
                        },
                        child: Text('Apply'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
