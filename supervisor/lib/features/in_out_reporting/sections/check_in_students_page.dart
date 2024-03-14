import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:supervisor/features/in_out_reporting/widgets/check_report_bottom_sheet.dart';
import 'package:supervisor/features/in_out_reporting/widgets/in_report_item.dart';

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
    BlocProvider.of<StudentCubit>(context).getStudentCheckIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        if(state.fetchI==RequestState.loading){
        return const CustomLoading();

        }
        if (state.studentsCheckIn != null) {
          if (state.studentsCheckIn!.isEmpty) {
            return const EmptyData(
                title: 'No Data', subtitle: 'No check-in request');
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
                        child: InReportingItem(
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
        return const CustomLoading();
      },
    );
  }
}
