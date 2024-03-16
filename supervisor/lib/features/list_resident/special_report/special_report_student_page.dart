import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/special_reports/special_report_response.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inkwell_container.dart';

import '../widgets/head_resident_page.dart';
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
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              return SupervisorSpecialReportCard(
                                data: state.specialReport!
                                    .listProblemConsultations![index],
                                id: widget.student.studentId!,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 12,
                              );
                            },
                            itemCount: state.specialReport!
                                .listProblemConsultations!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
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

class SupervisorSpecialReportCard extends StatelessWidget {
  final String id;
  final ListProblemConsultation data;
  const SupervisorSpecialReportCard(
      {super.key, required this.data, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      radius: 12,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 6,
            color: const Color(0xFFD4D4D4).withOpacity(.25)),
        BoxShadow(
            offset: const Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
            color: const Color(0xFFD4D4D4).withOpacity(.25)),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Problem Consultation',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              if (data.verificationStatus == 'VERIFIED')
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: primaryColor,
                ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const ItemDivider(),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Encountered Problems',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            data.content!.trim(),
            style: textTheme.bodyMedium?.copyWith(height: 1.2),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Provided Solutions',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          const SizedBox(
            height: 4,
          ),
          (data.solution != null)
              ? Text(
                  data.solution!.trim(),
                  style: textTheme.bodyMedium?.copyWith(height: 1.2),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: onFormDisableColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'no solution provided yet',
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
