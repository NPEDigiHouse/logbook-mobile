import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';

import '../widgets/head_resident_page.dart';
import '../../special_report/widgets/special_report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialReportStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const SpecialReportStudentPage({
    super.key,
    required this.student,
  });

  @override
  State<SpecialReportStudentPage> createState() =>
      _SpecialReportStudentPageState();
}

class _SpecialReportStudentPageState extends State<SpecialReportStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SpecialReportCubit>(context)
          .getSpecialReportByStudentId(studentId: widget.student.studentId!);
    });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<SpecialReportCubit>(context)
                .getSpecialReportByStudentId(
                    studentId: widget.student.studentId!),
          ]);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ...getHeadSection(
                title: title,
                subtitle: 'Problem Consultations',
                student: widget.student),
            SliverToBoxAdapter(
              child: BlocBuilder<SpecialReportCubit, SpecialReportState>(
                builder: (context, state) {
                  if (state.specialReport != null) {
                    if (state
                        .specialReport!.listProblemConsultations!.isNotEmpty) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          // ListView.separated(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   itemBuilder: (context, index) {
                          //     return SupervisorSpecialReportCard(
                          //       data: state.specialReport!
                          //           .listProblemConsultations![index],
                          //       id: widget.student.studentId!,
                          //       index: index + 1,
                          //     );
                          //   },
                          //   separatorBuilder: (context, index) {
                          //     return const SizedBox(
                          //       height: 12,
                          //     );
                          //   },
                          //   itemCount: state.specialReport!
                          //       .listProblemConsultations!.length,
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          // ),
                        ],
                      );
                    } else {
                      return const EmptyData(
                          title: 'Empty Data',
                          subtitle: 'No Problem Consultations submitted');
                    }
                  }
                  return const CustomLoading();
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
