import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/headers/unit_student_header.dart';

import 'widgets/special_report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialReportDetailPage2 extends StatefulWidget {
  final String id;
  const SpecialReportDetailPage2({
    super.key,
    required this.id,
  });

  @override
  State<SpecialReportDetailPage2> createState() =>
      _SpecialReportDetailPage2State();
}

class _SpecialReportDetailPage2State extends State<SpecialReportDetailPage2> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpecialReportCubit>(context)
        .getSpecialReportDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submitted Problem Consultation"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SpecialReportCubit>(context)
                  .getSpecialReportDetail(id: widget.id),
            ]);
          },
          child: BlocConsumer<SpecialReportCubit, SpecialReportState>(
            listener: (context, state) {
              if (state.isVerifySpecialReportSuccess) {
                CustomAlert.success(
                    message:
                        'Success Provide Solution for Problem Consultation',
                    context: context);
                BlocProvider.of<SpecialReportCubit>(context)
                    .getSpecialReportDetail(id: widget.id);
                BlocProvider.of<SpecialReportCubit>(context)
                    .getSpecialReportStudents();
              }
            },
            builder: (context, state) {
              if (state.detailState == RequestState.loading) {
                return const CustomLoading();
              } else if (state.specialReportDetail != null) {
                return CustomScrollView(
                  // padding: const EdgeInsets.symmetric(vertical: 16),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StudentDepartmentHeader(
                          unitName: state.specialReportDetail?.departmentName ??
                              '...',
                          studentId:
                              state.specialReportDetail?.studentName ?? '...',
                          studentName:
                              state.specialReportDetail?.studentName ?? '...',
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            SupervisorSpecialReportCard(
                              data: state.specialReportDetail!,
                              id: widget.id,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return const CustomLoading();
            },
          ),
        ),
      ),
    );
  }
}
