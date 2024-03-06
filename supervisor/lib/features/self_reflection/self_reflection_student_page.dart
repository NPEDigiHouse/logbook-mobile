import 'package:core/context/navigation_extension.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/unit_student_header.dart';

import 'supervisor_self_reflection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorSelfReflectionStudentPage extends StatefulWidget {
  final String id;
  const SupervisorSelfReflectionStudentPage({super.key, required this.id});

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
        .getDetailSelfReflections(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted Self Reflecton'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  .getDetailSelfReflections(id: widget.id)
            ]);
          },
          child: BlocConsumer<SelfReflectionSupervisorCubit,
              SelfReflectionSupervisorState>(
            listener: (context, state) {
              if (state.requestStateVerifiy == RequestState.data) {
                CustomAlert.success(
                    message: 'Success Verify Self Reflection',
                    context: context);
                BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                    .getDetailSelfReflections(id: widget.id);
              }
            },
            builder: (context, state) {
              if (state.detailState == RequestState.loading) {
                return const CustomLoading();
              } else if (state.data != null) {
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
                          studentId: state.data?.studentId?? '...',
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
                    SliverToBoxAdapter(
                      child: SupervisorSelfReflectionCard(
                        data: state.data!,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
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
