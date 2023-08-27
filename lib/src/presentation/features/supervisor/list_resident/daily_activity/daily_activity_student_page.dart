import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyActivityStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const DailyActivityStudentPage({super.key, required this.student});

  @override
  State<DailyActivityStudentPage> createState() =>
      _DailyActivityStudentPageState();
}

class _DailyActivityStudentPageState extends State<DailyActivityStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
    BlocProvider.of<DailyActivityCubit>(context)
      ..getDailyActivitiesBySupervisor(studentId: widget.student.studentId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ...getHeadSection(
                title: title,
                subtitle: 'Daily Activity',
                student: widget.student),
            BlocBuilder<DailyActivityCubit, DailyActivityState>(
              builder: (context, state) {
                if (state.studentDailyActivity != null)
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount:
                          state.studentDailyActivity!.dailyActivities!.length,
                      itemBuilder: (context, index) {
                        return DailyActivityHomeCard(
                          dailyActivity: state
                              .studentDailyActivity!.dailyActivities![index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 12,
                        );
                      },
                    ),
                  );
                else
                  return SliverToBoxAdapter(
                    child: SizedBox(),
                  );
              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
