import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';

class UpdateStatusAllDialog extends StatefulWidget {
  final bool? status;

  const UpdateStatusAllDialog({
    super.key,
    this.status,
  });

  @override
  State<UpdateStatusAllDialog> createState() => _UpdateStatusAllDialogState();
}

class _UpdateStatusAllDialogState extends State<UpdateStatusAllDialog> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    status = widget.status ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                      'Update All Status Week',
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The status is not synchronized, so choose on or off and then submit.',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Status',
                      child: Switch.adaptive(
                        activeColor: primaryColor,
                        value: status,
                        inactiveThumbColor: onFormDisableColor,
                        trackOutlineWidth: const MaterialStatePropertyAll(.5),
                        trackOutlineColor:
                            const MaterialStatePropertyAll(secondaryTextColor),
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
                      .updateAllDailyActivityStatus(status: status);
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
