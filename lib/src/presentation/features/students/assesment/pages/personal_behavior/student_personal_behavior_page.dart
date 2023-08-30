import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/personal_behavior/student_personal_behavior_detail.dart';
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
        child: SingleChildScrollView(
          child: SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              horizontalPadding: 16,
              spacing: 12,
              children: [
                SizedBox(
                  height: 16,
                ),
                UnitHeader(unitName: widget.unitName),
                BlocBuilder<AssesmentCubit, AssesmentState>(
                  builder: (context, state) {
                    if (state.personalBehaviorStudent != null) {
                      if (state.personalBehaviorStudent!.isEmpty) {
                        return SizedBox();
                      }
                      final sa = state.personalBehaviorStudent!.first;
                      return WrapperScientificAssignment(id: sa.id!);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ]),
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
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
