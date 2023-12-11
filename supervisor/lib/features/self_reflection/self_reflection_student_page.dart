import 'package:core/context/navigation_extension.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/unit_student_header.dart';

import 'supervisor_self_reflection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorSelfReflectionStudentPage extends StatefulWidget {
  final String studentId;
  const SupervisorSelfReflectionStudentPage(
      {super.key, required this.studentId});

  @override
  State<SupervisorSelfReflectionStudentPage> createState() =>
      _SupervisorSelfReflectionStudentPageState();
}

class _SupervisorSelfReflectionStudentPageState
    extends State<SupervisorSelfReflectionStudentPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SelfReflectionSupervisorCubit>(context)
      .getDetailSelfReflections(id: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Self Reflecton'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  .getDetailSelfReflections(id: widget.studentId)
            ]);
          },
          child: BlocConsumer<SelfReflectionSupervisorCubit,
              SelfReflectionSupervisorState>(
            listener: (context, state) {
              if (state.requestStateVerifiy == RequestState.data) {
                BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  ..getDetailSelfReflections(id: widget.studentId)
                  ..reset();
              }
            },
            builder: (context, state) {
              if (state.data == null) {
                return const CustomLoading();
              }
              return CustomScrollView(
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
                        unitName: state.data?.activeDepartmentName,
                        studentId: widget.studentId,
                        studentName: state.data?.studentName ?? '...',
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SectionDivider(),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 12,
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.data!.listSelfReflections?.length,
                    itemBuilder: (context, index) {
                      return SupervisorSelfReflectionCard(
                        data: state.data!.listSelfReflections![index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
