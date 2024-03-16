import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/students/student_check_in_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/verify_dialog.dart';

class CheckReportBottomSheet extends StatefulWidget {
  final String title;
  final int iconQuarterTurns;
  final StudentCheckInModel student;

  const CheckReportBottomSheet({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
    required this.student,
  });

  @override
  State<CheckReportBottomSheet> createState() => _CheckReportBottomSheetState();
}

class _CheckReportBottomSheetState extends State<CheckReportBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentCubit, StudentState>(
      listener: (context, state) {
        if (state.successVerifyCheckIn) {
          CustomAlert.success(
              message: "Success Response Check-In Request", context: context);
          BlocProvider.of<StudentCubit>(context).getStudentCheckIn();
          context.back();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
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
                  RotatedBox(
                    quarterTurns: widget.iconQuarterTurns,
                    child: const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const ItemDivider(),
              const SizedBox(height: 16),
              Text(
                'Department Name',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              Text(
                widget.student.unitName!,
                style: textTheme.titleMedium,
              ),
              Text(
                'Send it on: ${Utils.datetimeToString(DateTime.fromMillisecondsSinceEpoch(widget.student.checkInTime! * 1000), isShowTime: true)}',
                style: textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    foregroundImage: AssetImage(
                      AssetPath.getImage('profile_default.png'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.student.fullname!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.student.studentId!,
                          style: textTheme.bodySmall?.copyWith(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style:
                          FilledButton.styleFrom(backgroundColor: errorColor),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierLabel: '',
                            barrierDismissible: false,
                            builder: (_) => VerifyDialog(
                                  onTap: () {
                                    BlocProvider.of<StudentCubit>(context)
                                        .verifyCheckIn(
                                            studentId:
                                                widget.student.studentId!,
                                            isVerified: false);
                                    Navigator.pop(context);
                                  },
                                  isSubmit: true,
                                ));
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Decline',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierLabel: '',
                            barrierDismissible: false,
                            builder: (_) => VerifyDialog(
                                  onTap: () {
                                    BlocProvider.of<StudentCubit>(context)
                                        .verifyCheckIn(
                                            studentId:
                                                widget.student.studentId!,
                                            isVerified: true);
                                    Navigator.pop(context);
                                  },
                                  isSubmit: true,
                                ));
                      },
                      icon: const Icon(
                        Icons.verified_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Accept',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
