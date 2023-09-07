import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/add_scientific_assignment_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/student_scientific_assignment_detail.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  final bool isSupervisingDPKExist;
  const StudentScientificAssignmentPage(
      {super.key, required this.unitName, required this.isSupervisingDPKExist});

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
                  if (state.scientificAssignmentStudents != null) {
                    if (state.scientificAssignmentStudents!.isEmpty) {
                      return SingleChildScrollView(
                        child: SpacingColumn(
                          onlyPading: true,
                          mainAxisAlignment: MainAxisAlignment.center,
                          horizontalPadding: 16,
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            if (!widget.isSupervisingDPKExist)
                              Text(
                                'Please select supervising dpk before upload scientific assignment data',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: errorColor,
                                ),
                              ),
                            EmptyData(
                                title: 'Empty Data',
                                subtitle:
                                    'Please upload scientific assignment data before!'),
                            SizedBox(
                              height: 12,
                            ),
                            Center(
                              child: FilledButton(
                                onPressed: widget.isSupervisingDPKExist
                                    ? () => context.navigateTo(
                                            AddScientificAssignmentPage(
                                          unitName: widget.unitName,
                                        ))
                                    : null,
                                child: Text('Add Scientific Assignment'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final sa = state.scientificAssignmentStudents!.first;
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
      child: CustomLoading(),
    );
  }
}
