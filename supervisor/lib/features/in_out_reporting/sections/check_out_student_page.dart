import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/students/student_check_out_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/profile_pic_placeholder.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:supervisor/features/in_out_reporting/widgets/out_report_item.dart';

class CheckOutReportPage extends StatefulWidget {
  final String title;
  final int iconQuarterTurns;

  const CheckOutReportPage({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
  });

  @override
  State<CheckOutReportPage> createState() => _CheckOutReportPageState();
}

class _CheckOutReportPageState extends State<CheckOutReportPage> {
  @override
  void initState() {
    BlocProvider.of<StudentCubit>(context).getStudentCheckOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        if (state.studentsCheckOut != null) {
          if (state.studentsCheckOut!.isEmpty) {
            return const EmptyData(
                title: 'No Data', subtitle: 'no student check out');
          }
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final hasSeparator =
                          index != state.studentsCheckOut!.length - 1;
                      final bottom = hasSeparator ? 12.0 : 0.0;

                      return Padding(
                        padding: EdgeInsets.only(bottom: bottom),
                        child: OutReportingItem(
                          student: state.studentsCheckOut![index],
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => CheckReportBottomSheet(
                              title: widget.title,
                              iconQuarterTurns: widget.iconQuarterTurns,
                              student: state.studentsCheckOut![index],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.studentsCheckOut!.length,
                  ),
                ),
              ),
            ],
          );
        }
        return const CustomLoading();
      },
    );
  }
}

class CheckReportBottomSheet extends StatefulWidget {
  final String title;
  final int iconQuarterTurns;
  final StudentCheckOutModel student;

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
        if (state.successVerifyCheckOut) {
          BlocProvider.of<StudentCubit>(context).getStudentCheckOut();
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
                  ProfilePicPlaceholder(
                      height: 56,
                      name: widget.student.fullname ?? '-',
                      width: 56,
                      isSmall: true),
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

              // TextFormField(
              //   minLines: 5,
              //   maxLines: 5,
              //   decoration: const InputDecoration(
              //     label: Text('Additional Notes'),
              //   ),
              // ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => VerifyDialog(
                              onTap: () {
                                BlocProvider.of<StudentCubit>(context)
                                    .verifyCheckOut(
                                        studentId: widget.student.studentId!);
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
                    'Verify',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
