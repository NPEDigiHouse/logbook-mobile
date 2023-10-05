import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/data/models/daily_activity/post_week_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_date_field.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddWeekDialog extends StatefulWidget {
  final bool? isExpired;
  final bool? isExpiredDate;
  final bool? status;
  final bool isEdit;
  final String departmentId;
  final int weekNum;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? id;

  const AddWeekDialog({
    this.status,
    this.isExpired,
    this.isExpiredDate,
    super.key,
    this.id,
    this.isEdit = false,
    this.endDate,
    this.startDate,
    required this.departmentId,
    required this.weekNum,
  });

  @override
  State<AddWeekDialog> createState() => _AddWeekDialogState();
}

class _AddWeekDialogState extends State<AddWeekDialog> {
  final ValueNotifier<bool> isEditActive = ValueNotifier(false);
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController weekNumController = TextEditingController();
  bool status = false;
  bool isExpiredDate = false;
  bool isExpired = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      isExpired = widget.isExpired ?? false;
      status = widget.status ?? false;
      isExpiredDate = widget.isExpiredDate ?? false;
      weekNumController.text = (widget.weekNum).toString();
      if (widget.startDate != null) {
        startDateController.text = Utils.datetimeToString(widget.startDate!);
      }
      if (widget.endDate != null) {
        endDateController.text = Utils.datetimeToString(widget.endDate!);
      }
    } else {
      weekNumController.text = (widget.weekNum + 1).toString();
      isEditActive.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyActivityCubit, DailyActivityState>(
      listener: (context, state) {
        if (state.isEditStatusWeek) {
          BlocProvider.of<DailyActivityCubit>(context)
            ..getListWeek(unitId: widget.departmentId);
          if (state.isEditWeekSuccess) {
            BlocProvider.of<DailyActivityCubit>(context)
              ..getListWeek(unitId: widget.departmentId);
          }
          Navigator.pop(context);
        }
        if (state.isAddWeekSuccess) {
          BlocProvider.of<DailyActivityCubit>(context)
            ..getListWeek(unitId: widget.departmentId);
          Navigator.pop(context);
        }
      },
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 36,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FormBuilder(
          key: _formKey,
          child: ValueListenableBuilder(
              valueListenable: isEditActive,
              builder: (context, state, _) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: onFormDisableColor,
                              ),
                              tooltip: 'Close',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                widget.isEdit ? 'Edit Week' : 'Add New Week',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      //   child: BuildTextField(
                      //     onChanged: (s) {},
                      //     isOnlyDigit: true,
                      //     isDisable: true,
                      //     isOnlyNumber: true,
                      //     label: 'Week Num',
                      //     controller: weekNumController,
                      //     validator: FormBuilderValidators.required(
                      //       errorText: 'This field is required',
                      //     ),
                      //   ),
                      // ),
                      if (widget.isEdit)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Week Status',
                                    ),
                                    Text(
                                      isExpired! && !status
                                          ? 'Expired'
                                          : 'Active',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: isExpired! && !status
                                            ? secondaryTextColor
                                            : successColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isExpiredDate!)
                                PopupMenuItem<String>(
                                  value: 'Status',
                                  child: Switch.adaptive(
                                    activeColor: primaryColor,
                                    value: status,
                                    inactiveThumbColor: onFormDisableColor,
                                    trackOutlineWidth:
                                        MaterialStatePropertyAll(.5),
                                    trackOutlineColor: MaterialStatePropertyAll(
                                        secondaryTextColor),
                                    onChanged: (value) {
                                      status = value;
                                      setState(() {});
                                      print(status);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (widget.isEdit)
                        CheckboxListTile(
                          value: state,
                          onChanged: (value) {
                            isEditActive.value = !isEditActive.value;
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          title: Text(
                            'Edit Date',
                            style: textTheme.bodyMedium,
                          ),
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -2),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      if (state) ...[
                        if (widget.isEdit) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'If you change the week\'s data, all previous daily activities for this week will be reset!',
                              style: textTheme.bodyMedium?.copyWith(
                                color: errorColor,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: InputDateField(
                            action: (d) {},
                            controller: startDateController,
                            hintText: 'Start Date',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              final sd = Utils.stringToDateTime(
                                  startDateController.text);
                              if (sd.weekday != DateTime.monday) {
                                return 'The startDate must be a Monday';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                          child: InputDateField(
                            action: (d) {
                              if (d.isBefore(DateTime.now())) {
                                status = false;
                                isExpiredDate = true;
                                isExpired = true;
                                setState(() {});
                              } else {
                                status = true;
                                isExpiredDate = false;
                                isExpired = false;
                                setState(() {});
                              }
                            },
                            controller: endDateController,
                            hintText: 'End Date',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              final sd = Utils.stringToDateTime(
                                  startDateController.text);
                              final ed = Utils.stringToDateTime(
                                  endDateController.text);
                              final difference = ed.difference(sd).inDays;
                              if (difference > 7) {
                                return 'Max ranges in a weeks is 7 days';
                              }
                              if (!ed.isAfter(sd)) {
                                return 'End Date must be after start date';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: FilledButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.saveAndValidate()) {
                              showDialog(
                                context: context,
                                barrierLabel: '',
                                barrierDismissible: false,
                                builder: (_) => VerifyDialog(
                                  onTap: () {
                                    final start = Utils.stringToDateTime(
                                        startDateController.text);
                                    final end = Utils.stringToDateTime(
                                        endDateController.text);
                                    if (widget.isEdit) {
                                      if (state) {
                                        BlocProvider.of<DailyActivityCubit>(
                                            context)
                                          ..editWeekByCoordinator(
                                            id: widget.id ?? '',
                                            postWeek: PostWeek(
                                              startDate: DateTime(
                                                          start.year,
                                                          start.month,
                                                          start.day,
                                                          13,
                                                          0,
                                                          0)
                                                      .millisecondsSinceEpoch ~/
                                                  1000,
                                              endDate: DateTime(
                                                          end.year,
                                                          end.month,
                                                          end.day,
                                                          13,
                                                          0,
                                                          0)
                                                      .millisecondsSinceEpoch ~/
                                                  1000,
                                              unitId: widget.departmentId,
                                              weekNum: int.parse(
                                                  weekNumController.text),
                                            ),
                                          );
                                      }
                                      BlocProvider.of<DailyActivityCubit>(
                                              context)
                                          .changeWeekStatus(
                                              status: status,
                                              id: widget.id ?? '');
                                    } else {
                                      BlocProvider.of<DailyActivityCubit>(
                                          context)
                                        ..addWeekByCoordinator(
                                          postWeek: PostWeek(
                                            startDate: DateTime(
                                                        start.year,
                                                        start.month,
                                                        start.day,
                                                        13,
                                                        0,
                                                        0)
                                                    .millisecondsSinceEpoch ~/
                                                1000,
                                            endDate: DateTime(
                                                        end.year,
                                                        end.month,
                                                        end.day,
                                                        13,
                                                        0,
                                                        0)
                                                    .millisecondsSinceEpoch ~/
                                                1000,
                                            unitId: widget.departmentId,
                                            weekNum: int.parse(
                                                weekNumController.text),
                                          ),
                                        );
                                    }
                                    Navigator.pop(context);
                                  },
                                  isSubmit: true,
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ).fullWidth(),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
