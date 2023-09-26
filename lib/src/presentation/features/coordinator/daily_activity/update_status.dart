import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStatusDialog extends StatefulWidget {
  final bool? isExpired;
  final bool? isExpiredDate;
  final bool? status;
  final String departmentId;
  final String? id;
  final int weekNum;

  const UpdateStatusDialog({
    super.key,
    this.status,
    required this.weekNum,
    required this.departmentId,
    this.isExpired,
    this.isExpiredDate,
    required this.id,
  });

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    status = widget.status ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyActivityCubit, DailyActivityState>(
      listener: (context, state) {
        if (state.isEditStatusWeek) {
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
        child: SingleChildScrollView(
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
                        'Update Status Week ${widget.weekNum}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 0, 20),
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
                              widget.isExpired! && !status
                                  ? 'Expired'
                                  : 'Active',
                              style: textTheme.titleSmall?.copyWith(
                                color: widget.isExpired! && !status
                                    ? secondaryTextColor
                                    : successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isExpiredDate!)
                        PopupMenuItem<String>(
                          value: 'Status',
                          child: Switch.adaptive(
                            activeColor: primaryColor,
                            value: status,
                            inactiveThumbColor: onFormDisableColor,
                            trackOutlineWidth: MaterialStatePropertyAll(.5),
                            trackOutlineColor:
                                MaterialStatePropertyAll(secondaryTextColor),
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
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: FilledButton(
                  onPressed: () {
                    BlocProvider.of<DailyActivityCubit>(context)
                        .changeWeekStatus(status: status, id: widget.id ?? '');
                  },
                  child: const Text('Submit'),
                ).fullWidth(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
