import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';

import 'widgets/special_report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialReportDetailPage extends StatefulWidget {
  final String studentId;
  const SpecialReportDetailPage({
    super.key,
    required this.studentId,
  });

  @override
  State<SpecialReportDetailPage> createState() =>
      _SpecialReportDetailPageState();
}

class _SpecialReportDetailPageState extends State<SpecialReportDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpecialReportCubit>(context)
      .getSpecialReportByStudentId(studentId: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Problem Consultations"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SpecialReportCubit>(context)
                  .getSpecialReportByStudentId(studentId: widget.studentId),
            ]);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SpacingColumn(
              onlyPading: true,
              horizontalPadding: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    BlocBuilder<SpecialReportCubit, SpecialReportState>(
                      builder: (context, state) {
                        if (state.specialReport != null) {
                          if (state.specialReport!.listProblemConsultations!
                              .isNotEmpty) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'List of Consultation on Encountered Issues',
                                  style: textTheme.titleMedium?.copyWith(
                                    height: 1.1,
                                    color: secondaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.separated(
                                  itemBuilder: (context, index) {
                                    return SupervisorSpecialReportCard(
                                      data: state.specialReport!
                                          .listProblemConsultations![index],
                                      studentId: widget.studentId,
                                      index: index + 1,
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
                          }
                          return const EmptyData(
                              title: 'Empty Data',
                              subtitle: 'No Problem Consultations submitted');
                        }
                        return const CustomLoading();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
