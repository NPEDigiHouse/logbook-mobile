import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/data/models/daily_activity/post_week_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_date_field.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWeekDialog extends StatefulWidget {
  final String departmentId;
  final int weekNum;

  const AddWeekDialog({
    super.key,
    required this.departmentId,
    required this.weekNum,
  });

  @override
  State<AddWeekDialog> createState() => _AddWeekDialogState();
}

class _AddWeekDialogState extends State<AddWeekDialog> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyActivityCubit, DailyActivityState>(
      listener: (context, state) {
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
                      'Add Week',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Week ${widget.weekNum + 1}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: InputDateField(
                  action: (d) {},
                  controller: startDateController,
                  hintText: 'Start Date'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: InputDateField(
                  action: (d) {},
                  controller: endDateController,
                  hintText: 'End Date'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: FilledButton(
                onPressed: () {
                  if (startDateController.text.isNotEmpty &&
                      endDateController.text.isNotEmpty) {
                    BlocProvider.of<DailyActivityCubit>(context)
                      ..addWeekByCoordinator(
                        postWeek: PostWeek(
                          startDate: ReusableFunctionHelper.stringToDateTime(
                                      startDateController.text)
                                  .millisecondsSinceEpoch ~/
                              1000,
                          endDate: ReusableFunctionHelper.stringToDateTime(
                                      endDateController.text)
                                  .millisecondsSinceEpoch ~/
                              1000,
                          unitId: widget.departmentId,
                          weekNum: (widget.weekNum + 1),
                        ),
                      );
                  }
                },
                child: const Text('Submit'),
              ).fullWidth(),
            ),
          ],
        ),
      ),
    );
  }
}
