import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/add_scientific_assignment_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/student_scientific_assignment_detail.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  const StudentScientificAssignmentPage({super.key, required this.unitName});

  @override
  State<StudentScientificAssignmentPage> createState() =>
      _StudentScientificAssignmentPageState();
}

class _StudentScientificAssignmentPageState
    extends State<StudentScientificAssignmentPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)..getStudentScientificAssignment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scientific Assignment"),
      ).variant(),
      body: SingleChildScrollView(
        child: SpacingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            horizontalPadding: 16,
            spacing: 12,
            children: [
              SizedBox(
                height: 16,
              ),
              // UnitHeader(unitName: widget.unitName),
              BlocBuilder<AssesmentCubit, AssesmentState>(
                builder: (context, state) {
                  if (state.scientificAssignmentStudents != null) {
                    if (state.scientificAssignmentStudents!.isEmpty) {
                      return SpacingColumn(
                        onlyPading: true,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          EmptyData(
                              title: 'Empty Data',
                              subtitle: 'Please upload mini cex data before!'),
                          SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: FilledButton(
                              onPressed: () => context
                                  .navigateTo(AddScientificAssignmentPage(
                                unitName: widget.unitName,
                              )),
                              child: Text('Add Scientific Assignment'),
                            ),
                          ),
                        ],
                      );
                    }
                    final sa = state.scientificAssignmentStudents!.first;
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
      ..getScientiicAssignmentDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.scientificAssignmentDetail != null)
          context.replace(ScientificAssignmentDetail(
            ss: state.scientificAssignmentDetail!,
          ));
      },
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
