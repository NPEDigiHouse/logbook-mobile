import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/students/student_check_in_model.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/profile_pic_placeholder.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckInReportPage extends StatefulWidget {
  final String title;
  final int iconQuarterTurns;

  const CheckInReportPage({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
  });

  @override
  State<CheckInReportPage> createState() => _CheckInReportPageState();
}

class _CheckInReportPageState extends State<CheckInReportPage> {
  @override
  void initState() {
    BlocProvider.of<StudentCubit>(context)..getStudentCheckIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        if ( state.studentsCheckIn != null) {
          if (state.studentsCheckIn!.isEmpty) {
            return EmptyData(title: 'No Data', subtitle: 'no student check in');
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
                          index != state.studentsCheckIn!.length - 1;
                      final bottom = hasSeparator ? 12.0 : 0.0;

                      return Padding(
                        padding: EdgeInsets.only(bottom: bottom),
                        child: InOutReportingItem(
                          student: state.studentsCheckIn![index],
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => CheckReportBottomSheet(
                              title: widget.title,
                              iconQuarterTurns: widget.iconQuarterTurns,
                              student: state.studentsCheckIn![index],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.studentsCheckIn!.length,
                  ),
                ),
              ),
            ],
          );
        }
        return CustomLoading();
      },
    );
  }
}

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
        if ( state.successVerifyCheckIn) {
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

              ItemDivider(),
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
              SizedBox(
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
                                    .verifyCheckIn(
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

class InOutReportingItem extends StatelessWidget {
  final StudentCheckInModel student;
  final VoidCallback? onTap;

  const InOutReportingItem({
    super.key,
    required this.student,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      color: scaffoldBackgroundColor,
      radius: 12,
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 10,
          color: Colors.black.withOpacity(.08),
        ),
      ],
      child: Row(
        children: <Widget>[
          ProfilePicPlaceholder(
              height: 56,
              name: student.fullname ?? '-',
              width: 56,
              isSmall: true),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.datetimeToString(
                      DateTime.fromMillisecondsSinceEpoch(
                          student.checkInTime! * 1000),
                      isShowTime: true),
                  style: textTheme.labelSmall?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.fullname ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  student.studentId ?? '-',
                  style: textTheme.bodySmall?.copyWith(
                    color: primaryColor,
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(
                      color: secondaryTextColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Department:\t',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: student.unitName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
