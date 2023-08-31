import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/personal_behavior/student_personal_behavior_detail.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPersonalBehaviorPage extends StatefulWidget {
  final String unitName;
  const StudentPersonalBehaviorPage({super.key, required this.unitName});

  @override
  State<StudentPersonalBehaviorPage> createState() =>
      _StudentPersonalBehaviorPageState();
}

class _StudentPersonalBehaviorPageState
    extends State<StudentPersonalBehaviorPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)..getStudentPersonalBehavior();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persoanl Behavior"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context)
                .getStudentScientificAssignment(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: BlocBuilder<AssesmentCubit, AssesmentState>(
                builder: (context, state) {
                  if (state.personalBehaviorStudent != null) {
                    if (state.personalBehaviorStudent!.isEmpty) {
                      return EmptyData(
                        subtitle: 'personal behavior empty',
                        title: 'No Personal Behavior',
                      );
                    }
                    final sa = state.personalBehaviorStudent!.first;
                    return WrapperScientificAssignment(id: sa.id!);
                  } else {
                    return CustomLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WrapperScientificAssignment extends StatefulWidget {
  final String id;
  const WrapperScientificAssignment({super.key, required this.id});

  @override
  State<WrapperScientificAssignment> createState() =>
      _WrapperScientificAssignmentState();
}

class _WrapperScientificAssignmentState
    extends State<WrapperScientificAssignment> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)
      ..getPersonalBehaviorDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.personalBehaviorDetail != null)
          context.replace(PersonalBehaviorDetailPage(
            pb: state.personalBehaviorDetail!,
          ));
      },
      child: CustomLoading(),
    );
  }
}
