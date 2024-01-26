import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';

class UpdateStatusDialog extends StatefulWidget {
  final bool? status;
  final bool? active;
  final String id;
  final String studentId;
  final int weekNum;

  const UpdateStatusDialog({
    super.key,
    this.status,
    this.active,
    required this.id,
    required this.studentId,
    required this.weekNum,
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
              .getDailyActivitiesBySupervisor(studentId: widget.studentId!);
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
                            const Text(
                              'Week Status',
                            ),
                            Text(
                              !widget.active! && !status ? 'Expired' : 'Active',
                              style: textTheme.titleSmall?.copyWith(
                                color: !widget.active! && !status
                                    ? secondaryTextColor
                                    : successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.active!)
                        PopupMenuItem<String>(
                          value: 'Status',
                          child: Switch.adaptive(
                            activeColor: primaryColor,
                            value: status,
                            inactiveThumbColor: onFormDisableColor,
                            trackOutlineWidth:
                                const MaterialStatePropertyAll(.5),
                            trackOutlineColor: const MaterialStatePropertyAll(
                                secondaryTextColor),
                            onChanged: (value) {
                              status = value;
                              setState(() {});
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
                        .updateDailyActivityStatus(
                            status: status, id: widget.id);
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
